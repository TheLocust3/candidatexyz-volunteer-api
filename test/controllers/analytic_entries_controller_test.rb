require 'test_helper'

class AnalyticEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @analytic_entry = analytic_entries(:one)

    user = authenticate_test # TODO: Don't auth every single time
    @campaign_id = user[:user]['campaignId']
    @analytic_entry.campaign_id = @campaign_id
    @analytic_entry.save

    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get analytic_entries_url, :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['analyticEntries'].nil?
    assert @response.parsed_body['analyticEntries'].length == 1
  end

  test "shouldn't get index without authentication" do
    get analytic_entries_url

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get analytic_entry_url(@analytic_entry), :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['id'] == @analytic_entry.id
  end

  test "shouldn't get show without authentication" do
    get analytic_entry_url(@analytic_entry)

    assert_response :unauthorized
  end

  test 'should create without authentication' do
    assert_difference('AnalyticEntry.count', 1) do
      post analytic_entries_url, :params => { payload: { data: 'data' }, campaign_id: @campaign_id }
    end

    assert_response :success
  end

  test 'should update with authentication' do
    patch analytic_entry_url(@analytic_entry), :params => { payload: { data: 'data2' } }.to_json, :headers => @auth_headers
    @analytic_entry.reload

    assert_response :success
    assert @analytic_entry.payload == { "data" => "data2" }
  end

  test "shouldn't update without authentication" do
    patch analytic_entry_url(@analytic_entry), :params => { payload: { data: 'data2' } }.to_json
    @analytic_entry.reload

    assert_response :unauthorized
    assert_not @analytic_entry.payload == { "data" => "data2" }
  end

  test 'should destroy with authentication' do
    assert_difference('AnalyticEntry.count', -1) do
      delete analytic_entry_url(@analytic_entry), :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't destroy without authentication" do
    assert_difference('AnalyticEntry.count', 0) do
      delete analytic_entry_url(@analytic_entry)
    end

    assert_response :unauthorized
  end

  # TODO: aggregate/ip tests
end
