class Report < ApplicationRecord  
  @@REPORT_TYPES = { ma: [
    { name: '8th day preceding preliminary', value: 'M102_edit_8_prelim', type: 'preliminaryDay', dueDate: '-8', endingDate: '-18' },
    { name: '8th day preceding election', value: 'M102_edit_8_elect', type: 'electionDay', dueDate: '-8', endingDate: '-18' },
    { name: '30 day after election', value: 'M102_edit_30_after', type: 'electionDay', dueDate: '30', endingDate: '20' },
    { name: 'Year-end report', value: 'M102_edit_year_end', dueDate: '2018-01-20', endingDate: '2018-12-31' }, # year is arbitrary
    { name: 'Dissolution', value: 'M102_edit_dissolution' }]
  }

  validates :campaign_id, presence: true

  validates :report_type, presence: true
  validates :status, presence: true
  validates :beginning_date, presence: true
  validates :ending_date, presence: true

  validate :dates

  monetize :ending_balance_cents

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
    if beginning_date > ending_date
        errors.add(:beginning_date, 'must be before ending date')
    end
  end
end
