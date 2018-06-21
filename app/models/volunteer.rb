class Volunteer < ApplicationRecord
  before_validation :sanitize_phone_number

  belongs_to :contact

  validates :campaign_id, presence: true
  validates :email, presence: true, email: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :zipcode, presence: true, zipcode: true

  validates :phone_number, number: true

  def save
    self.contact = Contact.new( campaign_id: self.campaign_id, email: self.email, first_name: self.first_name, last_name: self.last_name, zipcode: self.zipcode, phone_number: self.phone_number )
    
    super
  end

  def update(params)
    self.contact.update( email: params[:email], first_name: params[:first_name], last_name: params[:last_name], zipcode: params[:zipcode], phone_number: params[:phone_number] )

    super(params)
  end

  private
  def sanitize_phone_number
    unless self.phone_number.nil?
      self.phone_number = self.phone_number.gsub('-', '').gsub('(', '').gsub(')', '') # (123)-123-1234
    end
  end
end
