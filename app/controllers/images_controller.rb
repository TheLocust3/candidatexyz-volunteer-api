class ImagesController < ApplicationController

    include CandidateXYZ::Concerns::Authenticatable
    before_action :authenticate
    before_action :authenticate_campaign_id, only: [ :create ]

    def index
        @images = Image.all

        render
    end

    def show
        @image = Image.where( :identifier => params[:identifier] ).first

        if @image.nil?
            not_found
        else
            render
        end
    end

    def create
        @image = Image.new(create_params(params))

        S3.put_object(bucket: bucket, key: key(@image), body: Base64.decode64(params[:image]), acl: 'public-read')
        @image.url = "https://s3.amazonaws.com/#{bucket}/#{key(@image)}"

        if @image.save
            render 'show'
        else
            render_errors(@image)
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
  