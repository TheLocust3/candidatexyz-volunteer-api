require 'test_helper'

class DonorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @receipt = receipts(:one)

    user = authenticate_test
    @receipt.campaign_id = user[:user]['campaignId']
    @receipt.save

    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get '/donors', :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['donors'].nil?
    assert @response.parsed_body['donors'].length == 1
  end

  test "shouldn't get index without authentication" do
    get '/donors'

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get "/donors/#{URI.encode(@receipt.name)}", :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['name'] == @receipt.name
  end

  test "shouldn't get show without authentication" do
    get "/donors/#{URI.encode(@receipt.name)}"

    assert_response :unauthorized
  end
end
