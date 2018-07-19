class Contact < ApplicationRecord
  before_validation :sanitize_phone_number

  validates :campaign_id, presence: true
  validates :email, presence: true, email: true
  validates :zipcode, zipcode: true
  validates :phone_number, number: true
  
  def self.to_csv
    super(%w{id first_name last_name email phone_number zipcode created_at})
  end

  private
  def sanitize_phone_number
    unless self.phone_number.nil?
      self.phone_number = self.phone_number.gsub('-', '').gsub('(', '').gsub(')', '').gsub('+', '')
    end
  end
end
