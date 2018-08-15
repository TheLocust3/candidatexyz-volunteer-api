require 'test_helper'

class CommitteesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @committee = committees(:one)

    user = authenticate_test
    @campaign_id = user[:user]['campaignId']
    @committee.campaign_id = @campaign_id
    @committee.save

    @auth_headers = user[:headers]
  end

  test "shouldn't get index without authentication" do
    get committees_url

    assert_response :unauthorized
  end

  test 'should show with authentication' do
    get committee_url(@committee), :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['id'] == @committee.id
  end

  test "shouldn't show without authentication" do
    get committee_url(@committee)

    assert_response :unauthorized
  end

  test 'should create with authentication' do
    assert_difference('Committee.count', 1) do
      post committees_url, :params => { name: 'Test Committee', email: 'test@gmail.com', phone_number: '781-315-5580', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', zipcode: '01867', office: 'Office', district: 'District', bank: 'Reading Cooperative Bank' }, :headers => @auth_headers, :as => :json
    end

    assert_response :success
  end

  test "shouldn't create without authentication" do
    assert_difference('Committee.count', 0) do
      post committees_url, :params => { name: 'Test Committee', email: 'test@gmail.com', phone_number: '781-315-5580', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', zipcode: '01867', office: 'Office', district: 'District', bank: 'Reading Cooperative Bank' }, :as => :json
    end

    assert_response :unauthorized
  end

  test 'should update with authentication' do
    patch committee_url(@committee), :params => { name: 'Test' }.to_json, :headers => @auth_headers
    @committee.reload

    assert_response :success
    assert @committee.name == 'Test'
  end

  test "shouldn't update without authentication" do
    patch committee_url(@committee), :params => { name: 'Test' }.to_json
    @committee.reload

    assert_response :unauthorized
    assert_not @committee.name == 'Test'
  end

  test 'should destroy with authentication' do
    assert_difference('Committee.count', -1) do
      delete committee_url(@committee), :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't destroy without authentication" do
    assert_difference('Committee.count', 0) do
      delete committee_url(@committee)
    end

    assert_response :unauthorized
  end
end
