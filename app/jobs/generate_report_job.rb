class GenerateReportJob < ApplicationJob
  queue_as :default

  def perform(report, campaign_id)
    report.status = 'generating'
    report.save

    report_state = ''
    for state in Report.REPORT_TYPES.keys
      matched_types = Report.REPORT_TYPES[state].select { |report_type| report_type[:value] == report.report_type  }
      if matched_types.length > 0
        report_state = state
      end
    end

    in_filename = "pdf/#{report_state}/#{report.report_type}.pdf"
    out_filename = "pdf/tmp/#{report.id}.pdf"
    json_filename = "pdf/tmp/#{report.id}.json"

    receipts = Receipt.where( :created_at => (report.beginning_date..report.ending_date), :campaign_id => campaign_id )
    expenditures = Expenditure.where( :created_at => (report.beginning_date..report.ending_date), :campaign_id => campaign_id )
    in_kinds = InKind.where( :created_at => (report.beginning_date..report.ending_date), :campaign_id => campaign_id )
    liabilities = Liability.where( :created_at => (report.beginning_date..report.ending_date), :campaign_id => campaign_id )

    reportJson = ReportJSON.new(report_state, report, receipts, expenditures, in_kinds, liabilities)
    reportJson.save(json_filename)

    `python3 pdf/fill_pdf.py #{in_filename} #{out_filename} #{json_filename}`

    bucket = "#{Rails.application.secrets.project_name}-reports"
    key = "#{campaign_id}/#{report.id}.pdf"

    # S3.put_object(bucket: bucket, key: key, body: File.binread(out_filename), acl: 'public-read')
    # File.delete(out_filename)

    report.status = 'done'
    report.save
  end
end
