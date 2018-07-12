class InKind < ApplicationRecord  
  validates :campaign_id, presence: true

  validates :from_whom, presence: true
  validates :description, presence: true

  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  
  validates :date_received, presence: true
  validates :value, presence: true

  monetize :value_cents
end
