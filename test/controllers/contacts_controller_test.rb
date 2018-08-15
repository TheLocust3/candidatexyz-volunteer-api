require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact = contacts(:one)

    user = authenticate_test
    @campaign_id = user[:user]['campaignId']
    @contact.campaign_id = @campaign_id
    @contact.save

    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get contacts_url, :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['contacts'].nil?
    assert @response.parsed_body['contacts'].length == 1
  end

  test "shouldn't get index without authentication" do
    get contacts_url

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get contact_url(@contact), :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['id'] == @contact.id
  end

  test "shouldn't get show without authentication" do
    get contact_url(@contact)

    assert_response :unauthorized
  end

  test 'should create without authentication' do
    assert_difference('Contact.count', 1) do
      post contacts_url, :params => { first_name: 'Test', last_name: 'Test', email: 'test@gmail.com', zipcode: '01867', campaign_id: @campaign_id }
    end

    assert_response :success
  end

  test 'should update with authentication' do
    patch contact_url(@contact), :params => { first_name: 'Test 2' }.to_json, :headers => @auth_headers
    @contact.reload

    assert_response :success
    assert @contact.first_name == 'Test 2'
  end

  test "shouldn't update without authentication" do
    patch contact_url(@contact), :params => { first_name: 'Test 2' }.to_json
    @contact.reload

    assert_response :unauthorized
    assert_not @contact.first_name == 'Test 2'
  end

  test 'should destroy with authentication' do
    assert_difference('Contact.count', -1) do
      delete contact_url(@contact), :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't destroy without authentication" do
    assert_difference('Contact.count', 0) do
      delete contact_url(@contact)
    end

    assert_response :unauthorized
  end

  test 'should export with authentication' do
    master_csv = CSV.read('test/fixtures/files/contacts.csv')

    get '/contacts/export', :headers => @auth_headers

    test_csv = CSV.parse(@response.parsed_body)

    assert_response :success
    assert master_csv[0] == test_csv[0]
    assert master_csv.length == test_csv.length
  end

  test "shouldn't export without authentication" do
    get '/contacts/export'

    assert_response :unauthorized
  end
end
