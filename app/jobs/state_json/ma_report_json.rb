require 'json'

module StateJSON
  class MAReportJSON
    attr_reader :data

    def initialize(report, receipts, expenditures, in_kinds, liabilities)
      @data = Hash.new

      @report = report
      @receipts = receipts
      @expenditures = expenditures
      @in_kinds = in_kinds
      @liabilities = liabilities

      generate
    end

    private
    def generate
      data['textfield'] = {
        'dtBegDate[0]': @report.beginning_date.strftime('%m/%d/%Y'),
        'dtEndDate[0]': @report.ending_date.strftime('%m/%d/%Y')
      }

      data['checkbox'] = {
        'cbCandWComm[0]': '/On'
      }

      if @report.report_type == 'M102_edit_8_prelim'
        data['checkbox']['cbPrePreliminary[0]'] = '/On'
      elsif @report.report_type == 'M102_edit_8_elect'
        data['checkbox']['cbPreElection[0]'] = '/On'
      elsif @report.report_type == 'M102_edit_30_after'
        data['checkbox']['cbPostElection[0]'] = '/On'
      elsif @report.report_type == 'M102_edit_year_end'
        data['checkbox']['cbYearEnd[0]'] = '/On'
      elsif @report.report_type == 'M102_edit_dissolution'
        data['checkbox']['cbDissolution[0]'] = '/On'
      end
    end
  end
end