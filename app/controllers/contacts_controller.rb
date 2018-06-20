class ContactsController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate

    def index
        @contacts = Contact.all

        render
    end

    def show
        @contact = Contact.find(params[:id])
        
        render
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
        @contact = Contact.find(params[:id])

        if @contact.update(update_params(params))
            render 'show'
        else
            render_errors(@contact)
        end
    end

    def destroy
        @contact = Contact.find(params[:id])
        @contact.destroy

        render_success
    end

    def unsubscribe
        token = Rails.application.message_verifier(:unsubscribe).verify(params[:token])
        contact = Contact.find(token)

        Contact.where( email: contact.email ).map { |contact|
            contact.destroy
        }

        render_success
    end

    private
    def create_params(params)
        params.permit(:email, :first_name, :last_name, :zipcode, :phone_number)
    end

    def update_params(params)
        params.permit(:email, :first_name, :last_name, :zipcode, :phone_number)
    end
end
