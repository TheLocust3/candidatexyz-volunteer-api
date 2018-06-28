class ContactsController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate, except: [ :create, :unsubscribe ]
    before_action :authenticate_campaign_id, except: [ :create, :unsubscribe ]

    def index
        @contacts = Contact.where( :campaign_id => @campaign_id )

        render
    end

    def show
        @contact = Contact.where( :id => params[:id], :campaign_id => @campaign_id ).first
        
        if @contact.nil?
            not_found
        else
            render
        end
    end

    def create
        @contact = Contact.new(create_params(params))

        if @contact.save
            render 'show'
        else
            render_errors(@contact)
        end
    end

    def update
        @contact = Contact.where( :id => params[:id], :campaign_id => @campaign_id ).first

        if @contact.update(update_params(params))
            render 'show'
        else
            render_errors(@contact)
        end
    end

    def destroy
        @contact = Contact.where( :id => params[:id], :campaign_id => @campaign_id ).first
        @contact.destroy

        render_success
    end

    private
    def create_params(params)
        params.permit(:email, :first_name, :last_name, :zipcode, :phone_number, :campaign_id)
    end

    def update_params(params)
        params.permit(:email, :first_name, :last_name, :zipcode, :phone_number)
    end
end
