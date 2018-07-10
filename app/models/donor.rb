class Donor < ApplicationRecord
    validates :campaign_id, presence: true
    validates :name, presence: true
    validates :address, presence: true
    validates :zipcode, presence: true, zipcode: true
    validates :city, presence: true
    validates :state, presence: true
    validates :date_received, presence: true
    validates :amount, presence: true
  end
    