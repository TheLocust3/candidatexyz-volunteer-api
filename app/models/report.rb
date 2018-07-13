class Report < ApplicationRecord  
  self.REPORT_TYPES = { ma: [
      { name: '8th day preceding preliminary', value: 'M102_edit_8_prelim' },
      { name: '8th day preceding election', value: 'M102_edit_8_elect' },
      { name: '30 day after election', value: 'M102_edit_30_after' },
      { name: 'Year-end report', value: 'M102_edit_year_end' },
      { name: 'Dissolution', value: 'M102_edit_dissolution' }] }

  validates :campaign_id, presence: true

  validates :report_type, presence: true
  validates :beginning_date, presence: true
  validates :ending_date, presence: true
end
