class Donor
    attr_reader :name, :person, :amount, :receipts, :in_kinds, :donations

    def self.all(campaign_id)
        receipts = Receipt.where( :campaign_id => campaign_id )
        in_kinds = InKind.where( :campaign_id => campaign_id )
        donations = self.merge_donations(receipts, in_kinds)

        donors = []
        donations.uniq { |donation| donation[:name] }.each do |donor_donation|
            donations_with_name = donations.select { |donation| donation[:name] == donor_donation[:name] }

            amount = Money.new(0)
            donations_with_name.each { |donation| amount += donation[:amount] }
            donors << Donor.new(donor_donation[:name], donor_donation[:person], amount, receipts, in_kinds, donations_with_name)
        end

        donors
    end

    def self.get(name, campaign_id)
        self.all(campaign_id).select { |donor| donor.name == name }.first
    end

    def initialize(name, person, amount, receipts, in_kinds, donations)
        @name = name
        @person = person
        @amount = amount
        @receipts = receipts
        @in_kinds = in_kinds
        @donations = donations
    end

    private
    def self.merge_donations(receipts, in_kinds)
        clean_receipts = receipts.map do |receipt|
            { id: receipt.id, name: receipt.name, amount: receipt.amount, person: receipt.person, date_received: receipt.date_received, address: receipt.address, city: receipt.city, state: receipt.state, country: receipt.country }
        end

        clean_in_kinds = in_kinds.map do |in_kind|
            { id: in_kind.id, name: in_kind.from_whom, amount: in_kind.value, person: in_kind.person, date_received: in_kind.date_received, address: in_kind.address, city: in_kind.city, state: in_kind.state, country: in_kind.country }
        end

        clean_receipts + clean_in_kinds
    end
end