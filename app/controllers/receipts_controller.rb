class ReceiptsController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate
    before_action :authenticate_campaign_id

    def index
        @receipts = Receipt.where( :campaign_id => @campaign_id )

        render
    end

    def show
        @receipt = Receipt.where( :id => params[:id], :campaign_id => @campaign_id ).first
        
        if @receipt.nil?
            not_found
        else
            render
        end
    end

    def create
        @receipt = Receipt.new(create_params(params))

        if @receipt.save
            render 'show'
        else
            render_errors(@receipt)
        end
    end

    def update
        @receipt = Receipt.where( :id => params[:id], :campaign_id => @campaign_id ).first

        if @receipt.update(update_params(params))
            render 'show'
        else
            render_errors(@receipt)
        end
    end

    def destroy
        @receipt = Receipt.where( :id => params[:id], :campaign_id => @campaign_id ).first
        @receipt.destroy

        render_success
    end

    private
    def create_params(params)
        params.permit(:name, :address, :zipcode, :city, :state, :date_received, :occupation, :employer, :amount, :campaign_id)
    end

    def update_params(params)
        params.permit(:name, :address, :zipcode, :city, :state, :date_received, :occupation, :employer, :amount)
    end
end
