class Expenditure < ApplicationRecord  
  include Rulable

  validates :campaign_id, presence: true

  validates :paid_to, presence: true
  validates :purpose, presence: true

  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  
  validates :date_paid, presence: true
  validates :amount, presence: true

  validate :rules

  monetize :amount_cents

  def self.to_csv
    super(%w{id paid_to purpose address city state country amount_cents date_paid created_at})
  end

  private
  def rules
    expenditure_actions = RulesOrganizer.rules['ma']['municipal']['expenditure'].check(self)

    handle_rules(expenditure_actions, self)
  end
end
