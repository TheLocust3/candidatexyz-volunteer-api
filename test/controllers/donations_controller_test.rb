require 'test_helper'

class DonationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    receipt = receipts(:one)
    in_kind = in_kinds(:one)

    user = authenticate_test
    receipt.campaign_id = user[:user]['campaignId']
    receipt.save

    in_kind.campaign_id = user[:user]['campaignId']
    in_kind.save

    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get '/donations', :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['donations'].nil?
    assert @response.parsed_body['donations'].length == 2
  end

  test "shouldn't get index without authentication" do
    get '/donations'

    assert_response :unauthorized
  end
end
