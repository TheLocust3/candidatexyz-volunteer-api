ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'httparty'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::JUnitReporter.new

class ActiveSupport::TestCase  
  fixtures :all

  def authenticate_test
    authenticate('test@gmail.com', 'password')
  end

  def authenticate(email, password)
    response = HTTParty.post("#{Rails.application.secrets.auth_api}/auth/sign_in", {
      query: { email: email, password: password }
    })

    { user: response['data'], headers: response.headers }
  end
end
