class InKind < ApplicationRecord  
  include Rulable

  before_validation :sanitize_phone_number

  validates :campaign_id, presence: true

  validates :from_whom, presence: true
  validates :description, presence: true

  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  
  validates :date_received, presence: true
  validates :value, presence: true

  validates :email, email: true
  validates :phone_number, number: true

  validate :rules

  monetize :value_cents

  def self.to_csv
    super(%w{id from_whom email phone_number description address city state country value_cents date_received created_at})
  end

  private
  def sanitize_phone_number
    unless self.phone_number.nil?
      self.phone_number = self.phone_number.gsub('-', '').gsub('(', '').gsub(')', '').gsub('+', '') # (123)-123-1234
    end
  end

  def rules
    donor = Donor.get(from_whom, campaign_id)
    donation_actions = RulesOrganizer.rules['ma']['municipal']['donation'].check(self, donor)
    in_kind_actions = RulesOrganizer.rules['ma']['municipal']['in_kind'].check(self, donor)

    handle_rules(donation_actions, self)
    handle_rules(in_kind_actions, self)
  end
end
