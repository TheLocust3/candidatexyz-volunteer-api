class VolunteersController < ApplicationController
    
    def index
        
    end

    def show

    end

    def create
        
    end

    def update
        
    end

    def destroy
        
    end

    private
    def create_params(params)
        params.permit(:email, :phone_number, :first_name, :last_name, :address, :zipcode, :city, :state, :help_blurb)
    end

    def update_params(params)
        params.permit(:email, :phone_number, :first_name, :last_name, :address, :zipcode, :city, :state, :help_blurb)
    end
end
