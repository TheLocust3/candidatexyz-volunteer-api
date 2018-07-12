class InKind < ApplicationRecord  
  before_validation :sanitize_phone_number

  validates :campaign_id, presence: true

  validates :from_whom, presence: true
  validates :description, presence: true

  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  
  validates :date_received, presence: true
  validates :value, presence: true

  validates :email, email: true
  validates :phone_number, number: true

  monetize :value_cents

  private
  def sanitize_phone_number
    unless self.phone_number.nil?
      self.phone_number = self.phone_number.gsub('-', '').gsub('(', '').gsub(')', '').gsub('+', '') # (123)-123-1234
    end
  end
end
