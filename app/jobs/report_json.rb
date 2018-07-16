require 'json'

class ReportJSON
  attr_reader :data

  def initialize(state, report, receipts, expenditures, in_kinds, liabilities, campaign, users)
    @report = report
    @receipts = receipts
    @expenditures = expenditures
    @in_kinds = in_kinds
    @liabilities = liabilities
    @campaign = campaign
    @users = users

    if state.to_s == 'ma'
      @data = StateJSON::MAReportJSON.new(report, receipts, expenditures, in_kinds, liabilities, campaign, users).data
    end
  end

  def save(filename)
    File.open(filename, 'w') { |file| file.write(JSON.generate(data)) }
  end
end