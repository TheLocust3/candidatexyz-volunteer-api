class ExpendituresController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate
    before_action :authenticate_campaign_id

    def index
        @expenditures = Expenditure.where( :campaign_id => @campaign_id )

        render
    end

    def show
        @expenditure = Expenditure.where( :id => params[:id], :campaign_id => @campaign_id ).first
        
        if @expenditure.nil?
            not_found
        else
            render
        end
    end

    def create
        @expenditure = Expenditure.new(create_params(params))

        if @expenditure.save
            render 'show'
        else
            render_errors(@expenditure)
        end
    end

    def update
        @expenditure = Expenditure.where( :id => params[:id], :campaign_id => @campaign_id ).first

        if @expenditure.update(update_params(params))
            render 'show'
        else
            render_errors(@expenditure)
        end
    end

    def destroy
        @expenditure = Expenditure.where( :id => params[:id], :campaign_id => @campaign_id ).first
        @expenditure.destroy

        render_success
    end

    def export
        expenditures = Expenditure.where( :campaign_id => @campaign_id )

        send_data(expenditures.to_csv, type: 'text/csv', disposition: 'inline')
    end

    private
    def create_params(params)
        params.permit(:paid_to, :purpose, :address, :city, :state, :country, :date_paid, :amount, :campaign_id)
    end

    def update_params(params)
        params.permit(:paid_to, :purpose, :address, :city, :state, :country, :date_paid, :amount)
    end
end
