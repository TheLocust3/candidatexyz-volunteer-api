class Donation
    attr_reader :id, :name, :type, :email, :phone_number, :person, :amount, :amountString, :occupation, :employer, :address, :city, :state, :country, :date_received

    def self.all(campaign_id)
        receipts = Receipt.where( :campaign_id => campaign_id )
        in_kinds = InKind.where( :campaign_id => campaign_id )

        self.create_raw(receipts, in_kinds)
    end

    def self.create_raw(receipts, in_kinds)
        receipt_donations = receipts.map { |receipt| self.create(receipt) }

        in_kind_donation = in_kinds.map { |in_kind| self.create(in_kind) }

        receipt_donations + in_kind_donation
    end

    def initialize(id, name, email, phone_number, person, amount, occupation, employer, address, city, state, country, date_received, type)
        @id = id
        @name = name
        @type = type
        @email = email
        @phone_number = phone_number
        @person = person
        @amount = amount
        @amountString = amount.to_s
        @occupation = occupation
        @employer = employer
        @address = address
        @city = city
        @state = state
        @country = country
        @date_received = date_received
    end

    private
    def self.create(receipt_or_in_kind)
        if receipt_or_in_kind.is_a? Receipt
            Donation.new(receipt_or_in_kind.id, receipt_or_in_kind.name, receipt_or_in_kind.email, receipt_or_in_kind.phone_number, receipt_or_in_kind.person, receipt_or_in_kind.amount, receipt_or_in_kind.occupation, receipt_or_in_kind.employer, receipt_or_in_kind.address, receipt_or_in_kind.city, receipt_or_in_kind.state, receipt_or_in_kind.country, receipt_or_in_kind.date_received, 'Receipt')
        elsif receipt_or_in_kind.is_a? InKind
            Donation.new(receipt_or_in_kind.id, receipt_or_in_kind.from_whom, receipt_or_in_kind.email, receipt_or_in_kind.phone_number, receipt_or_in_kind.person, receipt_or_in_kind.value, nil, nil, receipt_or_in_kind.address, receipt_or_in_kind.city, receipt_or_in_kind.state, receipt_or_in_kind.country, receipt_or_in_kind.date_received, 'In Kind')
        end
    end
end