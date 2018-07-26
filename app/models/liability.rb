class Liability < ApplicationRecord
  include Rulable

  validates :campaign_id, presence: true

  validates :to_whom, presence: true
  validates :purpose, presence: true

  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true

  validates :date_incurred, presence: true
  validates :amount, presence: true

  validate :rules

  monetize :amount_cents

  def self.to_csv
    super(%w{id to_whom purpose address city state country amount_cents date_incurred created_at})
  end

  private
  def rules
    liability_actions = RulesOrganizer.rules['ma']['municipal']['liability'].check(self)

    handle_rules(liability_actions, self)
  end
end
