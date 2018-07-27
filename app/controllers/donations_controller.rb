class DonationsController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable

    before_action :authenticate
    before_action :authenticate_campaign_id

    def index
        @donations = Donation.all(@campaign_id)

        render
    end
end
