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
        @report.data = params[:data]
        @base_url = base_url

        if @report.save
            Notification.create!( :title => 'Campaign Finance report is being processed', :body => 'A Campaign Finance report is being generated', :link => "/finance/reports/#{@report.id}", :campaign_id => @campaign_id )
            
            auth_headers = {
              uid: request.headers['uid'],
              client: request.headers['client'],
              'access-token': request.headers['access-token']
            }
            FinanceReportJob.perform_later(auth_headers, @report, @campaign_id)

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
        params.permit(:report_type, :official, :report_class, :campaign_id)
    end

    def update_params(params)
        params.permit(:report_type)
    end

    def base_url
        "https://s3.amazonaws.com/#{bucket}/reports/#{@campaign_id}"
    end

    def bucket
        "#{Rails.application.secrets.project_name}-public"
    end

    def key(report)
        "reports/#{@campaign_id}/#{report.id}.pdf"
    end
end
