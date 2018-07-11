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

    def aggregate
        if params[:start].nil? || params[:end].nil? || params[:by].nil?
            render_400
            return
        end

        start_time = params[:start].to_datetime
        end_time = params[:end].to_datetime
        
        all_analytic_entries = AnalyticEntry.where( :campaign_id => @campaign_id, :created_at => start_time..end_time )
        @analytic_entries = normalize_entries(all_analytic_entries, params[:by])

        render 'aggregate'
    end

    def show
        @analytic_entry = AnalyticEntry.where( :id => params[:id], :campaign_id => @campaign_id ).first
        
        if @analytic_entry.nil?
            not_found
        else
            render
        end
    end

    def create
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

    private
    def normalize_entries(entries, by)        
        normalized_entries = entries.map { |entry|
            created_at = entry.created_at
            if by == 'hour'
                DateTime.new(created_at.year, created_at.month, created_at.day, created_at.hour, 0, 0)
            elsif by == 'day'
                DateTime.new(created_at.year, created_at.month, created_at.day, 4, 0, 0)
            elsif by == 'month'
                DateTime.new(created_at.year, created_at.month, 1, 0, 0, 0)
            else by == 'year'
                DateTime.new(created_at.year, 1, 1, 0, 0, 0)
            end
        }

        normalized_entries.uniq.map { |entry|
            { datetime: entry, hits: normalized_entries.count(entry) }
        }
    end
end
