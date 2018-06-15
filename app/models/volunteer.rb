class Volunteer < ApplicationRecord
    before_validation :sanitize_phone_number
  
    belongs_to :contact
  
    validates :email, presence: true, email: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :zipcode, presence: true, zipcode: true
  
    validates :phone_number, number: true
  
    private
    def sanitize_phone_number
      unless self.phone_number.nil?
        self.phone_number = self.phone_number.gsub('-', '').gsub('(', '').gsub(')', '') # (123)-123-1234
      end
    end
  end
  