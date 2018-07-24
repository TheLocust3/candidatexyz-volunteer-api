class NotificationsController < ApplicationController
    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate
    before_action :authenticate_campaign_id

    def index
        @notifications = Notification.where( :campaign_id => @campaign_id, :user_id => [@current_user.id, ''] )

        render
    end

    def show
        @notification = Notification.where( :id => params[:id], :campaign_id => @campaign_id, :user_id => @current_user.id ).first
        
        if @notification.nil?
            not_found
        else
            render
        end
    end

    def create
        @notification = Notification.new(create_params(params))
        if @notification.campaign_id != @campaign_id && !@current_user.superuser
            render :json => {}, :status => 401

            return
        end

        if @notification.save
            render 'show'
        else
            render_errors(@notification)
        end
    end

    def update
        @notification = Notification.where( :id => params[:id], :campaign_id => @campaign_id, :user_id => [@current_user.id, ''] ).first

        if @notification.update(update_params(params))
            render 'show'
        else
            render_errors(@notification)
        end
    end

    def destroy
        @notification = Notification.where( :id => params[:id], :campaign_id => @campaign_id, :user_id => @current_user.id ).first
        @notification.destroy

        render_success
    end

    private
    def create_params(params)
        params.permit(:title, :body, :link, :campaign_id, :user_id)
    end

    def update_params(params)
        params.permit(:read)
    end
end
