class LiabilitiesController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate
    before_action :authenticate_campaign_id

    def index
        @liabilities = Liability.where( :campaign_id => @campaign_id )

        render
    end

    def show
        @liability = Liability.where( :id => params[:id], :campaign_id => @campaign_id ).first
        
        if @liability.nil?
            not_found
        else
            render
        end
    end

    def create
        @liability = Liability.new(create_params(params))

        if @liability.save
            render 'show'
        else
            render_errors(@liability)
        end
    end

    def update
        @liability = Liability.where( :id => params[:id], :campaign_id => @campaign_id ).first

        if @liability.update(update_params(params))
            render 'show'
        else
            render_errors(@liability)
        end
    end

    def destroy
        @liability = Liability.where( :id => params[:id], :campaign_id => @campaign_id ).first
        @liability.destroy

        render_success
    end

    def export
        liabilities = Liability.where( :campaign_id => @campaign_id )

        send_data(liabilities.to_csv, type: 'text/csv', disposition: 'inline')
    end

    private
    def create_params(params)
        params.permit(:to_whom, :purpose, :address, :city, :state, :country, :date_incurred, :amount, :campaign_id)
    end

    def update_params(params)
        params.permit(:to_whom, :purpose, :address, :city, :state, :country, :date_incurred, :amount)
    end
end
