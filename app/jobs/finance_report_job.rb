require 'json'

class FinanceReportJob < ApplicationJob
  include CandidateXYZ::Concerns::Request

  queue_as :default

  def perform(headers, report, campaign_id)
    begin
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

      out_filename = "pdf/tmp/#{report.id}.pdf"
      json_filename = "pdf/tmp/#{report.id}.json"

      receipts = Receipt.where( :created_at => (report.beginning_date..report.ending_date), :campaign_id => campaign_id )
      expenditures = Expenditure.where( :created_at => (report.beginning_date..report.ending_date), :campaign_id => campaign_id )
      in_kinds = InKind.where( :created_at => (report.beginning_date..report.ending_date), :campaign_id => campaign_id )
      liabilities = Liability.where( :created_at => (report.beginning_date..report.ending_date), :campaign_id => campaign_id )
      campaign = get("#{Rails.application.secrets.auth_api}/campaigns/#{campaign_id}")

      users = get("#{Rails.application.secrets.auth_api}/users/users_with_committee_positions?campaign_id=#{campaign_id}")['users']
      error = check_users(users)
      unless error.empty?
        report.status = error
        report.save

        return
      end

      committee = Committee.where( :campaign_id => campaign_id ).first
      if committee.nil?
        report.status = 'Error: Missing committee'
        report.save

        return
      end

      last_report = Report.order('created_at DESC').where( :report_class => 'finance', :official => true ).select { |r| r.ending_date == report.beginning_date }.first

      reportJson = FinanceReportJSON.new(report_state, report, receipts, expenditures, in_kinds, liabilities, campaign, users, committee, last_report)
      reportJson.save(json_filename)

      `python3 pdf/fill_pdf.py #{out_filename} #{json_filename}`

      bucket = "#{Rails.application.secrets.project_name}-public"
      key = "reports/#{campaign_id}/#{report.id}.pdf"

      S3.put_object(bucket: bucket, key: key, body: File.binread(out_filename), acl: 'public-read')
      File.delete(out_filename)
      File.delete(json_filename)

      Notification.create!( :title => 'Campaign Finance report has been generated', :body => 'The Campaign Finance report documents can now be viewed', :link => "/finance/reports/#{report.id}", :campaign_id => campaign_id )

      report.status = 'done'
      report.save
    rescue Exception => e
      puts e
      puts e.backtrace

      report.status = 'error'
      report.save
    end
  end

  private
  def auth_headers
    @headers
  end

  def check_users(users)
    ['Candidate', 'Chairman', 'Treasurer'].each do |position|
      missing = true
      users.each do |user|
        if user.position == position
          missing = false
        end
      end

      if missing
        return "Error: Missing #{position} in campaign staff"
      end
    end

    return ''
  end
end
