class InKindsController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate
    before_action :authenticate_campaign_id

    def index
        @in_kinds = InKinds.where( :campaign_id => @campaign_id )

        render
    end

    def show
        @in_kind = InKinds.where( :id => params[:id], :campaign_id => @campaign_id ).first
        
        if @in_kind.nil?
            not_found
        else
            render
        end
    end

    def create
        @in_kind = InKinds.new(create_params(params))

        if @in_kind.save
            render 'show'
        else
            render_errors(@in_kind)
        end
    end

    def update
        @in_kind = InKinds.where( :id => params[:id], :campaign_id => @campaign_id ).first

        if @in_kind.update(update_params(params))
            render 'show'
        else
            render_errors(@in_kind)
        end
    end

    def destroy
        @in_kind = InKinds.where( :id => params[:id], :campaign_id => @campaign_id ).first
        @in_kind.destroy

        render_success
    end

    private
    def create_params(params)
        params.permit(:from_whom, :description, :address, :city, :state, :country, :date_received, :value, :email, :phone_number, :campaign_id)
    end

    def update_params(params)
        params.permit(:from_whom, :description, :address, :city, :state, :country, :date_received, :value, :email, :phone_number)
    end
end
