require 'json'

class GenerateReportJob < ApplicationJob
  include CandidateXYZ::Concerns::Request

  queue_as :default

  def perform(headers, report, campaign_id)
    @headers = headers

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
    campaign = get("#{Rails.application.secrets.auth_api}/campaigns/#{campaign_id}")
    users = get("#{Rails.application.secrets.auth_api}/campaigns/users_with_committee_positions?id=#{campaign_id}")['users']
    committee = get("#{Rails.application.secrets.auth_api}/committee_by_campaign")
    last_report = Report.order('created_at DESC').where( :official => true, :ending_date => report.beginning_date ).first

    reportJson = ReportJSON.new(report_state, report, receipts, expenditures, in_kinds, liabilities, campaign, users, committee, last_report)
    reportJson.save(json_filename)

    `python3 pdf/fill_pdf.py #{in_filename} #{out_filename} #{json_filename}`

    bucket = "#{Rails.application.secrets.project_name}-public"
    key = "reports/#{campaign_id}/#{report.id}.pdf"

    S3.put_object(bucket: bucket, key: key, body: File.binread(out_filename), acl: 'public-read')
    File.delete(out_filename)
    File.delete(json_filename)

    report.status = 'done'
    report.save
  end

  private
  def auth_headers
    @headers
  end
end
