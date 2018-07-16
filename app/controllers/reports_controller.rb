class ReportsController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate
    before_action :authenticate_campaign_id

    def index
        @reports = Report.where( :campaign_id => @campaign_id )
        @base_url = base_url

        render
    end

    def show
        @report = Report.where( :id => params[:id], :campaign_id => @campaign_id ).first
        @base_url = base_url
        
        if @report.nil?
            not_found
        else
            render
        end
    end

    def report_types
        @report_types = Report.REPORT_TYPES

        render 'report_types'
    end

    def create
        @report = Report.new(create_params(params))
        @base_url = base_url

        if @report.save
            auth_headers = {
              uid: request.headers['uid'],
              client: request.headers['client'],
              'access-token': request.headers['access-token']
            }
            GenerateReportJob.perform_later(auth_headers, @report, @campaign_id)

            render 'show'
        else
            render_errors(@report)
        end
    end

    def destroy
        @report = Report.where( :id => params[:id], :campaign_id => @campaign_id ).first
        @report.destroy

        S3.delete_object(bucket: bucket, key: key(@report))

        render_success
    end

    private
    def create_params(params)
        params.permit(:report_type, :beginning_date, :ending_date, :campaign_id)
    end

    def update_params(params)
        params.permit(:report_type, :beginning_date, :ending_date)
    end

    def base_url
        "https://s3.amazonaws.com/#{bucket}/#{@campaign_id}"
    end

    def bucket
        "#{Rails.application.secrets.project_name}-reports"
    end

    def key(report)
        "#{@campaign_id}/#{report.id}.pdf"
    end
end
