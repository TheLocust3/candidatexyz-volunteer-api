class Donor
    attr_reader :name, :email, :phone_number, :person, :amount, :occupation, :employer, :address, :city, :state, :country, :receipts, :in_kinds, :donations

    def self.all(campaign_id)
        receipts = Receipt.where( :campaign_id => campaign_id )
        in_kinds = InKind.where( :campaign_id => campaign_id )
        donations = self.merge_donations(receipts, in_kinds)

        donors = []
        donations.uniq { |donation| donation[:name] }.each do |donor_donation|
            donations_with_name = donations.select { |donation| donation[:name] == donor_donation[:name] }

            amount = Money.new(0)
            donations_with_name.each { |donation| amount += donation[:amount] }
            donors << Donor.new(donor_donation[:name], donor_donation[:email], donor_donation[:phone_number], donor_donation[:person], amount, donor_donation[:occupation], donor_donation[:employer], donor_donation[:address], donor_donation[:city], donor_donation[:state], donor_donation[:country], receipts, in_kinds, donations_with_name)
        end

        donors
    end

    def self.get(name, campaign_id)
        self.all(campaign_id).select { |donor| donor.name == name }.first
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
    def self.merge_donations(receipts, in_kinds)
        clean_receipts = receipts.map do |receipt|
            { id: receipt.id, name: receipt.name, email: receipt.email, phone_number: receipt.phone_number, amount: receipt.amount, person: receipt.person, occupation: receipt.occupation, employer: receipt.employer, date_received: receipt.date_received, address: receipt.address, city: receipt.city, state: receipt.state, country: receipt.country }
        end

        clean_in_kinds = in_kinds.map do |in_kind|
            { id: in_kind.id, name: in_kind.from_whom, email: in_kind.email, phone_number: in_kind.phone_number, amount: in_kind.value, person: in_kind.person, date_received: in_kind.date_received, address: in_kind.address, city: in_kind.city, state: in_kind.state, country: in_kind.country }
        end

        clean_receipts + clean_in_kinds
    end
end