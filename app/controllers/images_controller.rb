class ImagesController < ApplicationController

    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate, only: [ :index, :create, :update, :destroy ]
    before_action :authenticate_campaign_id, only: [ :create ]

    def index
        render :json => Image.all
    end

    def show
        render :json => Image.where( :identifier => params[:identifier] ).first
    end

    def create
        image = Image.new(create_params(params))

        S3.put_object(bucket: bucket, key: key(image), body: Base64.decode64(params[:image]), acl: 'public-read')
        image.url = "https://s3.amazonaws.com/#{bucket}/#{key(image)}"

        if image.save
            render :json => image
        else
            render_errors(image)
        end
    end

    def destroy
        image = Image.find(params[:id])
        image.destroy

        S3.delete_object(bucket: bucket, key: key(image))

        render_success
    end

    private
    def create_params(params)
        params.permit(:identifier)
    end

    def bucket
        "#{Rails.application.secrets.project_name}-images"
    end

    def key(image)
        "#{@campaign_id}/#{image.identifier}"
    end
  end
  