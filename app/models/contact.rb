class Contact < ApplicationRecord
    before_validation :sanitize_phone_number
  
    validates :email, presence: true, email: true
    validates :zipcode, zipcode: true
    validates :phone_number, number: true
  
    private
    def sanitize_phone_number
      unless self.phone_number.nil?
        self.phone_number = self.phone_number.gsub(/\D/, '') # remove non-numbers
      end
    end
end
  