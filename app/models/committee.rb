class Committee < ApplicationRecord
  before_validation :sanitize_phone_number
  before_destroy :destroy_reports

  validates :name, presence: true
  validates :email, presence: true, email: true
  validates :phone_number, presence: true, number: true

  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :zipcode, presence: true, zipcode: true

  validates :office, presence: true
  validates :district, presence: true

  validates :bank, presence: true

  validates :campaign_id, presence: true

  def report
    Report.where( :campaign_id => campaign_id ).select { |report| report.data['committee_id'] == id && report.report_type_name == 'Creation' }.first
  end

  def dissolution_report
    Report.where( :campaign_id => campaign_id ).select { |report| report.data['committee_id'] == id && report.report_type_name == 'Dissolution' }.first
  end

  private
  def sanitize_phone_number
    unless self.phone_number.nil?
      self.phone_number = self.phone_number.gsub('-', '').gsub('(', '').gsub(')', '').gsub('+', '') # (123)-123-1234
    end
  end

  def destroy_reports
    Report.where( :campaign_id => campaign_id ).map { |report| report.destroy }
  end
end
