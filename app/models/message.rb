class Message < ApplicationRecord
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, email: true
    validates :subject, presence: true
    validates :message, presence: true
  end
  