class Donor
    attr_reader :name, :email, :phone_number, :person, :amount, :occupation, :employer, :address, :city, :state, :country, :receipts, :in_kinds, :donations

    def self.all(campaign_id)
        receipts = Receipt.where( :campaign_id => campaign_id )
        in_kinds = InKind.where( :campaign_id => campaign_id )
        
        self.create(receipts, in_kinds)
    end

    def self.get(name, campaign_id)
        receipts = Receipt.where( :name => name, :campaign_id => campaign_id )
        in_kinds = InKind.where( :from_whom => name, :campaign_id => campaign_id )

        self.create(receipts, in_kinds).first
    end

    def initialize(name, email, phone_number, person, amount, occupation, employer, address, city, state, country, receipts, in_kinds, donations)
        @name = name
        @email = email
        @phone_number = phone_number
        @person = person
        @amount = amount
        @occupation = occupation
        @employer = employer
        @address = address
        @city = city
        @state = state
        @country = country
        @receipts = receipts
        @in_kinds = in_kinds
        @donations = donations
    end

    private
    def self.create(receipts, in_kinds)
        donations = Donation.create_raw(receipts, in_kinds)

        donors = []
        donations.uniq { |donation| donation.name }.each do |donor_donation|
            donations_with_name = donations.select { |donation| donation.name == donor_donation.name }

            fields = self.pull_fields(donations_with_name)
            donors << Donor.new(donor_donation.name, fields[:email], fields[:phone_number], donor_donation.person, fields[:amount], fields[:occupation], fields[:employer], fields[:address], fields[:city], fields[:state], fields[:country], receipts, in_kinds, donations_with_name)
        end

        donors
    end

    def self.pull_fields(donations)
        fields = Hash.new
        donations = donations.sort_by { |donation| donation.date_received }

        fields[:amount] = Money.new(0)
        donations.each { |donation| fields[:amount] += donation.amount }

        for donation in donations
            self.pull_field(:email, fields, donation)
            self.pull_field(:phone_number, fields, donation)
            self.pull_field(:occupation, fields, donation)
            self.pull_field(:employer, fields, donation)
            self.pull_field(:address, fields, donation)
            self.pull_field(:city, fields, donation)
            self.pull_field(:state, fields, donation)
            self.pull_field(:country, fields, donation)
        end

        fields
    end

    def self.pull_field(symbol, fields, donation)
        if fields[symbol].nil? && !donation.send(symbol).nil? && !donation.send(symbol).empty?
            fields[symbol] = donation.send(symbol)
        end
    end
end