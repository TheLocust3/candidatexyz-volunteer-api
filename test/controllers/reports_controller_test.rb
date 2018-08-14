require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @report = reports(:one)

    user = authenticate_test
    @campaign_id = user[:user]['campaignId']
    @report.campaign_id = @campaign_id
    @report.save

    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get reports_url, :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['reports'].nil?
    assert @response.parsed_body['reports'].length == 1
  end

  test "shouldn't get index without authentication" do
    get reports_url

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get report_url(@report), :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['id'] == @report.id
  end

  test "shouldn't get show without authentication" do
    get report_url(@report)

    assert_response :unauthorized
  end

  # TODO: Actually test create/update/destroy
end
