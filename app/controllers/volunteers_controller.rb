class VolunteersController < ApplicationController
    
    def index
        @volunteers = Volunteer.all

        render
    end

    def show
        @volunteer = Volunteer.find(params[:id])
        
        render
    end

    def create
        @volunteer = Volunteer.new(create_params(params))

        if @volunteer.save
            render 'show'
        else
            render_errors(@volunteer)
        end
    end

    def update
        @volunteer = Volunteer.find(params[:id])

        if @volunteer.update(update_params(params))
            render 'show'
        else
            render_errors(@volunteer)
        end
    end

    def destroy
        @volunteer = Volunteer.find(params[:id])
        @volunteer.destroy

        render_success
    end

    private
    def create_params(params)
        params.permit(:email, :phone_number, :first_name, :last_name, :address, :zipcode, :city, :state, :help_blurb)
    end

    def update_params(params)
        params.permit(:email, :phone_number, :first_name, :last_name, :address, :zipcode, :city, :state, :help_blurb)
    end
end
