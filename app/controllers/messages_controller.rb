class MessagesController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate, except: [ :create ]
    before_action :authenticate_campaign_id, except: [ :create ]

    def index
        @messages = Message.where( :campaign_id => @campaign_id )

        render
    end

    def show
        @message = Message.where( :id => params[:id], :campaign_id => @campaign_id ).first

        if @message.nil?
            not_found
        else
            render
        end
    end

    def create
        @message = Message.new(create_params(params))

        if @message.save
            render 'show'
        else
            render_errors(@message)
        end
    end

    def destroy
        @message = Message.where( :id => params[:id], :campaign_id => @campaign_id ).first
        @message.destroy

        render_success
    end

    def export
        messages = Message.where( :campaign_id => @campaign_id )

        send_data(messages.to_csv, type: 'text/csv', disposition: 'inline')
    end

    private
    def create_params(params)
        params.permit(:first_name, :last_name, :email, :subject, :message, :campaign_id)
    end
end
  