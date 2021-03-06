require 'json'

class FinanceReportJSON
  attr_reader :data

  def initialize(state, report, receipts, expenditures, in_kinds, liabilities, campaign, users, committee, last_report)
    @report = report
    @receipts = receipts
    @expenditures = expenditures
    @in_kinds = in_kinds
    @liabilities = liabilities
    @campaign = campaign
    @users = users
    @committee = committee
    @last_report = last_report

    if state.to_s == 'ma'
      if campaign['officeType'] == 'Municipal'
        @data = FinanceJSON::MAMunicipalReportJSON.new(report, receipts, expenditures, in_kinds, liabilities, campaign, users, committee, last_report).data
      end
    end
  end

  def save(filename)
    File.open(filename, 'w') { |file| file.write(JSON.generate(data)) }

    generate_ending_balance
  end

  private
  def generate_ending_balance
    last_balance = Money.new(0)
    unless @last_report.nil?
      last_balance = Money.new(@last_report.data['ending_balance'])
    end

    positive = Money.new(0)
    @receipts.each { |receipt| positive += receipt.amount }

    negative = Money.new(0)
    @expenditures.each { |expenditure| negative += expenditure.amount }

    @report.data['ending_balance'] = Money.new(positive + last_balance - negative).to_f
    @report.save
  end
end
