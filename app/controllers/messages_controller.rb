class MessagesController < ApplicationController

    def index
        @messages = Message.all

        render
    end

    def show
        @message = Message.find(params[:id])

        render
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
        @message = Message.find(params[:id])
        @message.destroy

        render_success
    end

    private
    def create_params(params)
        params.permit(:first_name, :last_name, :email, :subject, :message)
    end
end
  