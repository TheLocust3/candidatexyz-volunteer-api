require 'test_helper'

class VolunteersControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = authenticate_test
    @campaign_id = user[:user]['campaignId']

    @volunteer = Volunteer.where( email: 'test@gmail.com' ).first

    if @volunteer.nil?
      # can't use fixtures because volunteer create makes contact
      @volunteer = Volunteer.create( first_name: 'Test', last_name: 'Test', email: 'test@gmail.com', address: '304 Franklin Street', city: 'Reading', state: 'MA', zipcode: '01867', help_blurb: 'Some help', campaign_id: @campaign_id )
    end

    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get volunteers_url, :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['volunteers'].nil?
    assert @response.parsed_body['volunteers'].length == 1
  end

  test "shouldn't get index without authentication" do
    get volunteers_url

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get volunteer_url(@volunteer), :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['id'] == @volunteer.id
  end

  test "shouldn't get show without authentication" do
    get volunteer_url(@volunteer)

    assert_response :unauthorized
  end

  test 'should create without authentication' do
    assert_difference('Volunteer.count', 1) do
      post volunteers_url, :params => { first_name: 'Test', last_name: 'Test', email: 'test@gmail.com', zipcode: '01867', campaign_id: @campaign_id }
    end

    assert_response :success
  end

  test 'should update with authentication' do
    patch volunteer_url(@volunteer), :params => { first_name: 'Test 2' }.to_json, :headers => @auth_headers
    @volunteer.reload

    assert_response :success
    assert @volunteer.first_name == 'Test 2'
  end

  test "shouldn't update without authentication" do
    patch volunteer_url(@volunteer), :params => { first_name: 'Test 2' }.to_json
    @volunteer.reload

    assert_response :unauthorized
    assert_not @volunteer.first_name == 'Test 2'
  end

  test 'should destroy with authentication' do
    assert_difference('Volunteer.count', -1) do
      delete volunteer_url(@volunteer), :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't destroy without authentication" do
    assert_difference('Volunteer.count', 0) do
      delete volunteer_url(@volunteer)
    end

    assert_response :unauthorized
  end

  test 'should get number of pages with authentication' do
    get '/volunteers/number-of-pages', :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body == 1
  end

  test "shouldn't get number of pages without authentication" do
    get '/volunteers/number-of-pages'

    assert_response :unauthorized
  end

  test 'should export with authentication' do
    master_csv = CSV.read('test/fixtures/files/volunteers.csv')

    get '/volunteers/export', :headers => @auth_headers

    test_csv = CSV.parse(@response.parsed_body)

    assert_response :success
    assert master_csv[0] == test_csv[0]
    assert master_csv.length == test_csv.length
  end

  test "shouldn't export without authentication" do
    get '/volunteers/export'

    assert_response :unauthorized
  end
end
