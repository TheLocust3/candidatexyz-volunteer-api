class Receipt < ApplicationRecord
  include CandidateXYZ::Concerns::Rulable

  before_validation :sanitize_phone_number

  validates :campaign_id, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :date_received, presence: true
  validates :amount, presence: true

  validates :receipt_type, presence: true
  validates :email, email: true
  validates :phone_number, number: true

  validate :rules

  monetize :amount_cents

  def self.to_csv
    super(%w{id name email phone_number address city state country amount_cents occupation employer created_at})
  end

  private
  def sanitize_phone_number
    unless self.phone_number.nil?
      self.phone_number = self.phone_number.gsub('-', '').gsub('(', '').gsub(')', '').gsub('+', '') # (123)-123-1234
    end
  end

  def rules
    donation_actions = RulesOrganizer.rules['ma']['municipal']['donation'].check(self, Donor.get(name, campaign_id))
    receipt_actions = RulesOrganizer.rules['ma']['municipal']['receipt'].check(self)

    handle_rules(donation_actions, self)
    handle_rules(receipt_actions, self)
  end
end
