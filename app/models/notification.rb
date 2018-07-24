class Notification < ApplicationRecord
  validates :campaign_id, presence: true

  validates :title, presence: true
  validates :body, presence: true
  validates :link, presence: true
end
