require 'test_helper'

class AnalyticEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = authenticate_test # TODO: Don't auth every single time
    @campaign_id = user[:user]['campaignId']

    [:one, :two, :three, :four, :five].map do |sym|
      entry = analytic_entries(sym)
      entry.campaign_id = @campaign_id
      entry.save
    end

    @auth_headers = user[:headers]

    @analytic_entry = analytic_entries(:one)
  end

  test 'should get index with authentication' do
    get analytic_entries_url, :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['analyticEntries'].nil?
    assert @response.parsed_body['analyticEntries'].length == 5
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

  test 'should get ip without authentication' do
    get '/ip'

    assert_response :success
    assert_not @response.parsed_body['ip'].nil?
    assert_not @response.parsed_body['ip'].empty?
  end

  test "shouldn't aggregate without authentication" do
    get '/analytic_entries/aggregate'

    assert_response :unauthorized
  end

  test 'should aggregate by year' do
    get "/analytic_entries/aggregate?start=#{DateTime.new(2018, 1, 1, 0, 0)}&end=#{DateTime.new(2019, 1, 1, 0, 0)}&by=year", :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['analyticEntries'].length == 1

    assert @response.parsed_body['analyticEntries'][0]['datetime'].to_datetime == DateTime.new(2018, 1, 1)
    assert @response.parsed_body['analyticEntries'][0]['hits'] == 5
  end

  test 'should aggregate by month' do
    get "/analytic_entries/aggregate?start=#{DateTime.new(2018, 1, 1, 0, 0)}&end=#{DateTime.new(2019, 1, 1, 0, 0)}&by=month", :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['analyticEntries'].length == 2

    assert @response.parsed_body['analyticEntries'][0]['datetime'].to_datetime == DateTime.new(2018, 1, 1)
    assert @response.parsed_body['analyticEntries'][0]['hits'] == 4

    assert @response.parsed_body['analyticEntries'][1]['datetime'].to_datetime == DateTime.new(2018, 2, 1)
    assert @response.parsed_body['analyticEntries'][1]['hits'] == 1
  end

  test 'should aggregate by day' do
    get "/analytic_entries/aggregate?start=#{DateTime.new(2018, 1, 1, 0, 0)}&end=#{DateTime.new(2019, 1, 1, 0, 0)}&by=day", :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['analyticEntries'].length == 3

    assert @response.parsed_body['analyticEntries'][0]['datetime'].to_datetime == DateTime.new(2018, 1, 1, 4)
    assert @response.parsed_body['analyticEntries'][0]['hits'] == 3

    assert @response.parsed_body['analyticEntries'][1]['datetime'].to_datetime == DateTime.new(2018, 1, 2, 4)
    assert @response.parsed_body['analyticEntries'][1]['hits'] == 1

    assert @response.parsed_body['analyticEntries'][2]['datetime'].to_datetime == DateTime.new(2018, 2, 1, 4)
    assert @response.parsed_body['analyticEntries'][2]['hits'] == 1
  end

  test 'should aggregate by hour' do
    get "/analytic_entries/aggregate?start=#{DateTime.new(2018, 1, 1, 0, 0)}&end=#{DateTime.new(2019, 1, 1, 0, 0)}&by=hour", :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['analyticEntries'].length == 4

    assert @response.parsed_body['analyticEntries'][0]['datetime'].to_datetime == DateTime.new(2018, 1, 1, 1)
    assert @response.parsed_body['analyticEntries'][0]['hits'] == 2

    assert @response.parsed_body['analyticEntries'][1]['datetime'].to_datetime == DateTime.new(2018, 1, 1, 11)
    assert @response.parsed_body['analyticEntries'][1]['hits'] == 1

    assert @response.parsed_body['analyticEntries'][2]['datetime'].to_datetime == DateTime.new(2018, 1, 2)
    assert @response.parsed_body['analyticEntries'][2]['hits'] == 1

    assert @response.parsed_body['analyticEntries'][3]['datetime'].to_datetime == DateTime.new(2018, 2, 1)
    assert @response.parsed_body['analyticEntries'][3]['hits'] == 1
  end
end
