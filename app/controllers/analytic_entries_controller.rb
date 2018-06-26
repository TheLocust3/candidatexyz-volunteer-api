class AnalyticEntriesController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate, except: [ :create, :ip ]
    before_action :authenticate_campaign_id, except: [ :create, :ip ]

    def ip
        render :json => { ip: request.remote_ip }
    end

    def index
        @analytic_entries = AnalyticEntry.where( :campaign_id => @campaign_id )

        render
    end

    def show
        @analytic_entry = AnalyticEntry.where( :id => params[:id], :campaign_id => @campaign_id ).first
        
        render
    end

    def create
        analytic_entries = AnalyticEntry.where( :ip => params[:ip], :campaign_id => params[:campaign_id] )
        if analytic_entries.select { |entry| (DateTime.now + 10.minutes) > entry.created_at }.length != 0
            render_success
            return
        end

        @analytic_entry = AnalyticEntry.new({ campaign_id: params[:campaign_id], ip: params[:ip], payload: params[:payload] })

        if @analytic_entry.save
            render 'show'
        else
            render_errors(@analytic_entry)
        end
    end

    def update
        @analytic_entry = AnalyticEntry.where( :id => params[:id], :campaign_id => @campaign_id ).first
        @analytic_entry.payload = params[:payload]

        if @analytic_entry.save
            render 'show'
        else
            render_errors(@analytic_entry)
        end
    end

    def destroy
        @analytic_entry = AnalyticEntry.where( :id => params[:id], :campaign_id => @campaign_id ).first
        @analytic_entry.destroy

        render_success
    end
end
