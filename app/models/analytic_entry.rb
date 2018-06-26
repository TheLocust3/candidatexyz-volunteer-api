class AnalyticEntry < ApplicationRecord    
  validates :campaign_id, presence: true
  validates :payload, presence: true
end
  