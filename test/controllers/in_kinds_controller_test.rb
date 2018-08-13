require 'test_helper'

class InKindsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @in_kind = in_kinds(:one)

    user = authenticate_test # TODO: Don't auth every single time
    @campaign_id = user[:user]['campaignId']
    @in_kind.campaign_id = @campaign_id
    @in_kind.save

    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get in_kinds_url, :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['inKinds'].nil?
    assert @response.parsed_body['inKinds'].length == 1
  end

  test "shouldn't get index without authentication" do
    get in_kinds_url

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get in_kind_url(@in_kind), :headers => @auth_headers

    assert_response :success
  end

  test "shouldn't get show without authentication" do
    get in_kind_url(@in_kind)

    assert_response :unauthorized
  end

  test 'should create with authentication' do
    assert_difference('InKind.count', 1) do
      post in_kinds_url, :params => { from_whom: 'Jake Kinsella', description: 'A description', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_received: DateTime.now, value: 30, campaign_id: @campaign_id }.to_json, :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't create without authentication" do
    assert_difference('InKind.count', 0) do
      post in_kinds_url, :params => { from_whom: 'Jake Kinsella', description: 'A description', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_received: DateTime.now, value: 30, campaign_id: @campaign_id }
    end

    assert_response :unauthorized
  end

  test 'should update with authentication' do
    patch in_kind_url(@in_kind), :params => { from_whom: 'Jake Kinsella 2' }.to_json, :headers => @auth_headers
    @in_kind.reload

    assert_response :success
    assert @in_kind.from_whom == 'Jake Kinsella 2'
  end

  test "shouldn't update without authentication" do
    patch in_kind_url(@in_kind), :params => { from_whom: 'Jake Kinsella 2' }.to_json
    @in_kind.reload

    assert_response :unauthorized
    assert_not @in_kind.from_whom == 'Jake Kinsella 2'
  end

  test 'should destroy with authentication' do
    assert_difference('InKind.count', -1) do
      delete in_kind_url(@in_kind), :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't destroy without authentication" do
    assert_difference('InKind.count', 0) do
      delete in_kind_url(@in_kind)
    end

    assert_response :unauthorized
  end
end
