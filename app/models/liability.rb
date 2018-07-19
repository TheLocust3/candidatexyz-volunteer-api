class Liability < ApplicationRecord    
  validates :campaign_id, presence: true

  validates :to_whom, presence: true
  validates :purpose, presence: true

  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true

  validates :date_incurred, presence: true
  validates :amount, presence: true

  monetize :amount_cents

  def self.to_csv
    super(%w{id to_whom purpose address city state country amount_cents date_incurred created_at})
  end
end
