require 'test_helper'

class LiabilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @liability = liabilities(:one)

    user = authenticate_test # TODO: Don't auth every single time
    @campaign_id = user[:user]['campaignId']
    @liability.campaign_id = @campaign_id
    @liability.save

    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get liabilities_url, :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['liabilities'].nil?
    assert @response.parsed_body['liabilities'].length == 1
  end

  test "shouldn't get index without authentication" do
    get liabilities_url

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get liability_url(@liability), :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['id'] == @liability.id
  end

  test "shouldn't get show without authentication" do
    get liability_url(@liability)

    assert_response :unauthorized
  end

  test 'should create with authentication' do
    assert_difference('Liability.count', 1) do
      post liabilities_url, :params => { to_whom: 'Jake Kinsella', purpose: 'A purpose', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_incurred: DateTime.now, amount: 30, receipt_type: 'donation', campaign_id: @campaign_id }.to_json, :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't create without authentication" do
    assert_difference('Liability.count', 0) do
      post liabilities_url, :params => { to_whom: 'Jake Kinsella', purpose: 'A purpose', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_incurred: DateTime.now, amount: 30, receipt_type: 'donation', campaign_id: @campaign_id }
    end

    assert_response :unauthorized
  end

  test 'should update with authentication' do
    patch liability_url(@liability), :params => { to_whom: 'Jake Kinsella 2' }.to_json, :headers => @auth_headers
    @liability.reload

    assert_response :success
    assert @liability.to_whom == 'Jake Kinsella 2'
  end

  test "shouldn't update without authentication" do
    patch liability_url(@liability), :params => { to_whom: 'Jake Kinsella 2' }.to_json
    @liability.reload

    assert_response :unauthorized
    assert_not @liability.to_whom == 'Jake Kinsella 2'
  end

  test 'should destroy with authentication' do
    assert_difference('Liability.count', -1) do
      delete liability_url(@liability), :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't destroy without authentication" do
    assert_difference('Liability.count', 0) do
      delete liability_url(@liability)
    end

    assert_response :unauthorized
  end
end
