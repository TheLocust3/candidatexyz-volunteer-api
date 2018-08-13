require 'test_helper'

class ReceiptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @receipt = receipts(:one)

    user = authenticate_test # TODO: Don't auth every single time
    @campaign_id = user[:user]['campaignId']
    @receipt.campaign_id = @campaign_id
    @receipt.save

    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get receipts_url, :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['receipts'].nil?
    assert @response.parsed_body['receipts'].length == 1
  end

  test "shouldn't get index without authentication" do
    get receipts_url

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get receipt_url(@receipt), :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['id'] == @receipt.id
  end

  test "shouldn't get show without authentication" do
    get receipt_url(@receipt)

    assert_response :unauthorized
  end

  test 'should create with authentication' do
    assert_difference('Receipt.count', 1) do
      post receipts_url, :params => { name: 'Jake Kinsella', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_received: DateTime.now, amount: 30, receipt_type: 'donation', campaign_id: @campaign_id }.to_json, :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't create without authentication" do
    assert_difference('Receipt.count', 0) do
      post receipts_url, :params => { name: 'Jake Kinsella', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_received: DateTime.now, amount: 30, receipt_type: 'donation', campaign_id: @campaign_id }
    end

    assert_response :unauthorized
  end

  test 'should update with authentication' do
    patch receipt_url(@receipt), :params => { name: 'Jake Kinsella 2' }.to_json, :headers => @auth_headers
    @receipt.reload

    assert_response :success
    assert @receipt.name == 'Jake Kinsella 2'
  end

  test "shouldn't update without authentication" do
    patch receipt_url(@receipt), :params => { name: 'Jake Kinsella 2' }.to_json
    @receipt.reload

    assert_response :unauthorized
    assert_not @receipt.name == 'Jake Kinsella 2'
  end

  test 'should destroy with authentication' do
    assert_difference('Receipt.count', -1) do
      delete receipt_url(@receipt), :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't destroy without authentication" do
    assert_difference('Receipt.count', 0) do
      delete receipt_url(@receipt)
    end

    assert_response :unauthorized
  end
end
