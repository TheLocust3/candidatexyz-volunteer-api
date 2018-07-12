class Expenditure < ApplicationRecord  
  validates :campaign_id, presence: true

  validates :paid_to, presence: true
  validates :purpose, presence: true

  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  
  validates :date_paid, presence: true
  validates :amount, presence: true

  monetize :amount_cents
end
