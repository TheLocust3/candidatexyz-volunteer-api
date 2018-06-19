require 'open-uri'
require 'json'

module Authenticatable
    extend ActiveSupport::Concern
  
    def authenticate
        begin
            response = URI.parse("#{Rails.application.secrets.auth_api}/auth/validate_token?uid=#{request.headers['uid']}&client=#{request.headers['client']}&access-token=#{request.headers['access-token']}").read
            data = JSON.parse(response)

            current_user = data['data']
        rescue
            render :json => {}, :status => 401
        end
    end
end
