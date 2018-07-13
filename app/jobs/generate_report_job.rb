class GenerateReportJob < ApplicationJob
  queue_as :default

  def perform(report, campaign_id)
    report_type = Report.REPORT_TYPES.map{ |state| state.select { |report_type| report_type } }.first.first

    # out_file_name = "pdf/tmp/#{@report.id}.pdf"

    # bucket = "#{Rails.application.secrets.project_name}-reports"
    # key = "#{campaign_id}/#{report.id}.pdf"

    # S3.put_object(bucket: bucket, key: key, body: File.binread(out_file_name), acl: 'public-read')
    # File.delete(out_file_name)
  end
end
