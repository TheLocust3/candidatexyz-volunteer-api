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

  test 'should create with authentication' do
    assert_difference('Report.count', 1) do
      post reports_url, :params => { report_type: 'M102_edit_8_prelim', official: false, report_class: 'finance', data: { beginning_date: DateTime.new(2018, 1, 1), ending_date: DateTime.new(2018, 2, 1) }, campaign_id: @campaign_id }, :headers => @auth_headers, :as => :json
    end

    assert_response :success
  end

  test "shouldn't create without authentication" do
    assert_difference('Report.count', 0) do
      post reports_url, :params => { report_type: 'M102_edit_8_prelim', official: false, report_class: 'finance', data: { beginning_date: DateTime.new(2018, 1, 1), ending_date: DateTime.new(2018, 2, 1) }, campaign_id: @campaign_id }, :as => :json
    end

    assert_response :unauthorized
  end

=begin
  test 'should destroy with authentication' do
    assert_difference('Report.count', -1) do
      delete report_url(@report), :headers => @auth_headers
    end

    assert_response :success
  end
=end

  test "shouldn't destroy without authentication" do
    assert_difference('Report.count', 0) do
      delete report_url(@report)
    end

    assert_response :unauthorized
  end
end
