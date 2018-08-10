class Report < ApplicationRecord  
  @@REPORT_TYPES = { ma: [
    { name: '8th day preceding preliminary', value: 'M102_edit_8_prelim', officeType: 'Municipal', reportClass: 'finance', type: 'preliminaryDay', dueDate: '-8', endingDate: '-18' },
    { name: '8th day preceding election', value: 'M102_edit_8_elect', officeType: 'Municipal', reportClass: 'finance', type: 'electionDay', dueDate: '-8', endingDate: '-18' },
    { name: '30 day after election', value: 'M102_edit_30_after', officeType: 'Municipal', reportClass: 'finance', type: 'electionDay', dueDate: '30', endingDate: '20' },
    { name: 'Year-end report', value: 'M102_edit_year_end', officeType: 'Municipal', reportClass: 'finance', dueDate: '2018-01-20', endingDate: '2018-12-31' }, # year is arbitrary
    { name: 'Dissolution', value: 'M102_edit_dissolution', officeType: 'Municipal', reportClass: 'committee' },
    { name: 'Creation', value: 'cpf_m101_18', officeType: 'Municipal', reportClass: 'committee' },
    { name: 'Creation', value: 'cpf_101', officeType: 'State', reportClass: 'committee' }]
  }

  validates :campaign_id, presence: true

  validates :report_type, presence: true
  validates :report_class, presence: true
  validates :status, presence: true

  validate :report_class_specific

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

  def beginning_date
    DateTime.parse(data['beginning_date'])
  end

  def ending_date
    DateTime.parse(data['ending_date'])
  end

  private
  def report_class_specific
    if report_class == 'finance'
      if data.nil? || data.empty?
        errors.add(:data, 'must include dates')

        return
      end

      if beginning_date > ending_date
          errors.add(:beginning_date, 'must be before ending date')
      end
    end
  end
end
