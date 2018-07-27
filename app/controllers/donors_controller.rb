class ReceiptsController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable

    before_action :authenticate
    before_action :authenticate_campaign_id

    def index
        donors = Donor.all(@campaign_id)

        render
    end

    def show
        donor = Donor.get(params[:id], @campaign_id)
        
        if donor.nil?
            not_found
        else
            render
        end
    end
end
