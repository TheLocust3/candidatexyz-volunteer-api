require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @message = messages(:one)

    user = authenticate_test
    @campaign_id = user[:user]['campaignId']
    @message.campaign_id = @campaign_id
    @message.save

    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get messages_url, :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['messages'].nil?
    assert @response.parsed_body['messages'].length == 1
  end

  test "shouldn't get index without authentication" do
    get messages_url

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get message_url(@message), :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['id'] == @message.id
  end

  test "shouldn't get show without authentication" do
    get message_url(@message)

    assert_response :unauthorized
  end

  test 'should create without authentication' do
    assert_difference('Message.count', 1) do
      post messages_url, :params => { first_name: 'Test', last_name: 'Test', email: 'test@gmail.com', subject: 'A Subject', message: 'A message', campaign_id: @campaign_id }
    end

    assert_response :success
  end

  test 'should destroy with authentication' do
    assert_difference('Message.count', -1) do
      delete message_url(@message), :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't destroy without authentication" do
    assert_difference('Message.count', 0) do
      delete message_url(@message)
    end

    assert_response :unauthorized
  end

  test 'should export with authentication' do
    master_csv = CSV.read('test/fixtures/files/messages.csv')

    get '/messages/export', :headers => @auth_headers

    test_csv = CSV.parse(@response.parsed_body)

    assert_response :success
    assert master_csv[0] == test_csv[0]
    assert master_csv.length == test_csv.length
  end

  test "shouldn't export without authentication" do
    get '/messages/export'

    assert_response :unauthorized
  end
end
