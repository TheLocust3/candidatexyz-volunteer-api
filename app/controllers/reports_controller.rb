class ReportsController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate
    before_action :authenticate_campaign_id

    def index
        @reports = Report.where( :campaign_id => @campaign_id )
        @base_url = base_url(report)

        render
    end

    def show
        @report = Report.where( :id => params[:id], :campaign_id => @campaign_id ).first
        @base_url = base_url(report)
        
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

        GenerateReportJob.perform_later(@report)

        @base_url = base_url(report)

        if @report.save
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

    def base_url(report)
        "https://s3.amazonaws.com/#{bucket}/#{@campaign_id}"
    end

    def bucket
        "#{Rails.application.secrets.project_name}-reports"
    end

    def key(report)
        "#{@campaign_id}/#{report.id}.pdf"
    end
end
