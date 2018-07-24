class Notification < ApplicationRecord
  validates :user_id, presence: true
  validates :campaign_id, presence: true

  validates :title, presence: true
  validates :body, presence: true
end
