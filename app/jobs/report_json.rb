require 'json'

class ReportJSON
  attr_reader :data

  def initialize(state, report, receipts, expenditures, in_kinds, liabilities)
    @report = report
    @receipts = receipts
    @expenditures = expenditures
    @in_kinds = in_kinds
    @liabilities = liabilities

    if state.to_s == 'ma'
      @data = StateJSON::MAReportJSON.new(report, receipts, expenditures, in_kinds, liabilities).data
    end
  end

  def save(filename)
    File.open(filename, 'w') { |file| file.write(JSON.generate(data)) }
  end
end