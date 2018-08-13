require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notification = notifications(:one)

    user = authenticate_test # TODO: Don't auth every single time
    @campaign_id = user[:user]['campaignId']
    @notification.campaign_id = @campaign_id
    @notification.save

    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get notifications_url, :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['notifications'].nil?
    assert @response.parsed_body['notifications'].length == 1
  end

  test "shouldn't get index without authentication" do
    get notifications_url

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get notification_url(@notification), :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['id'] == @notification.id
  end

  test "shouldn't get show without authentication" do
    get notification_url(@notification)

    assert_response :unauthorized
  end

  test 'should create with authentication' do
    assert_difference('Notification.count', 1) do
      post notifications_url, :params => { title: 'Title', body: 'Body of notification', link: 'www.google.com', campaign_id: @campaign_id }.to_json, :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't create without authentication" do
    assert_difference('Notification.count', 0) do
      post notifications_url, :params => { title: 'Title', body: 'Body of notification', link: 'www.google.com', campaign_id: @campaign_id }
    end

    assert_response :unauthorized
  end

  test 'should update with authentication' do
    patch notification_url(@notification), :params => { read: true }.to_json, :headers => @auth_headers
    @notification.reload

    assert_response :success
    assert @notification.read
  end

  test "shouldn't update without authentication" do
    patch notification_url(@notification), :params => { read: true }.to_json
    @notification.reload

    assert_response :unauthorized
    assert_not @notification.read
  end

  test 'should destroy with authentication' do
    assert_difference('Notification.count', -1) do
      delete notification_url(@notification), :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't destroy without authentication" do
    assert_difference('Notification.count', 0) do
      delete notification_url(@notification)
    end

    assert_response :unauthorized
  end
end
