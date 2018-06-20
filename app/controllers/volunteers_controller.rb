class VolunteersController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate
    
    def index
        if (params[:page_number].nil?)
            @volunteers = Volunteer.all
        else
            @volunteers = filter_by_page
        end

        render
    end

    def get_number_of_pages
        records_per_page = params[:records_per_page].nil? ? 10 : params[:records_per_page].to_i
        render :json => (filter.length / records_per_page.to_f).ceil
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

    def filter_by_page
        records_per_page = params[:records_per_page].nil? ? 10 : params[:records_per_page].to_i

        filter[(params[:page_number].to_i) * records_per_page, records_per_page]
    end

    def filter
        order = params[:order].nil? ? 'created_at' : params[:order]
        descending = params[:descending] == 'true' ? 'desc' : 'asc'
        
        Volunteer.all.order(order => descending)
    end
end
