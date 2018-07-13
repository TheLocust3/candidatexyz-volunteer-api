class Report < ApplicationRecord  
  @@REPORT_TYPES = { ma: [
      { name: '8th day preceding preliminary', value: 'M102_edit_8_prelim' },
      { name: '8th day preceding election', value: 'M102_edit_8_elect' },
      { name: '30 day after election', value: 'M102_edit_30_after' },
      { name: 'Year-end report', value: 'M102_edit_year_end' },
      { name: 'Dissolution', value: 'M102_edit_dissolution' }] }

  validates :campaign_id, presence: true

  validates :report_type, presence: true
  validates :beginning_date, presence: true
  validates :ending_date, presence: true

  validate :dates

  def self.REPORT_TYPES
    @@REPORT_TYPES
  end

  def report_type_name
    for key in @@REPORT_TYPES.keys
        types = @@REPORT_TYPES[key].select { |state_report_type| state_report_type[:value] == report_type }
        if types.length > 0
            return types.first[:name]
        end
    end
  end

  private
  def dates
    if self.persisted?
        if beginning_date > ending_date
            errors.add(:beginning_date, 'must be before ending date')

            self.reload
        end
    end
  end
end
