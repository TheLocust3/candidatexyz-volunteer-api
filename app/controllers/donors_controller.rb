class DonorsController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate
    before_action :authenticate_campaign_id

    def index
        @donors = Donor.where( :campaign_id => @campaign_id )

        render
    end

    def show
        @donor = Donor.where( :id => params[:id], :campaign_id => @campaign_id ).first
        
        if @donor.nil?
            not_found
        else
            render
        end
    end

    def create
        @donor = Donor.new(create_params(params))

        if @donor.save
            render 'show'
        else
            render_errors(@donor)
        end
    end

    def update
        @donor = Donor.where( :id => params[:id], :campaign_id => @campaign_id ).first

        if @donor.update(update_params(params))
            render 'show'
        else
            render_errors(@donor)
        end
    end

    def destroy
        @donor = Donor.where( :id => params[:id], :campaign_id => @campaign_id ).first
        @donor.destroy

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
