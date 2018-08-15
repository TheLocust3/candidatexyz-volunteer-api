require 'test_helper'

class ExpendituresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expenditure = expenditures(:one)

    user = authenticate_test
    @campaign_id = user[:user]['campaignId']
    @expenditure.campaign_id = @campaign_id
    @expenditure.save

    @auth_headers = user[:headers]
  end

  test 'should get index with authentication' do
    get expenditures_url, :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['expenditures'].nil?
    assert @response.parsed_body['expenditures'].length == 1
  end

  test "shouldn't get index without authentication" do
    get expenditures_url

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get expenditure_url(@expenditure), :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['id'] == @expenditure.id
  end

  test "shouldn't get show without authentication" do
    get expenditure_url(@expenditure)

    assert_response :unauthorized
  end

  test 'should create with authentication' do
    assert_difference('Expenditure.count', 1) do
      post expenditures_url, :params => { paid_to: 'Jake Kinsella', purpose: 'A purpose', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_paid: DateTime.now, amount: 30, receipt_type: 'donation', campaign_id: @campaign_id }.to_json, :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't create without authentication" do
    assert_difference('Expenditure.count', 0) do
      post expenditures_url, :params => { paid_to: 'Jake Kinsella', purpose: 'A purpose', address: '304 Franklin Street', city: 'Reading', state: 'MA', country: 'United States', date_paid: DateTime.now, amount: 30, receipt_type: 'donation', campaign_id: @campaign_id }
    end

    assert_response :unauthorized
  end

  test 'should update with authentication' do
    patch expenditure_url(@expenditure), :params => { paid_to: 'Jake Kinsella 2' }.to_json, :headers => @auth_headers
    @expenditure.reload

    assert_response :success
    assert @expenditure.paid_to == 'Jake Kinsella 2'
  end

  test "shouldn't update without authentication" do
    patch expenditure_url(@expenditure), :params => { paid_to: 'Jake Kinsella 2' }.to_json
    @expenditure.reload

    assert_response :unauthorized
    assert_not @expenditure.paid_to == 'Jake Kinsella 2'
  end

  test 'should destroy with authentication' do
    assert_difference('Expenditure.count', -1) do
      delete expenditure_url(@expenditure), :headers => @auth_headers
    end

    assert_response :success
  end

  test "shouldn't destroy without authentication" do
    assert_difference('Expenditure.count', 0) do
      delete expenditure_url(@expenditure)
    end

    assert_response :unauthorized
  end

  test 'should export with authentication' do
    master_csv = CSV.read('test/fixtures/files/expenditures.csv')

    get '/expenditures/export', :headers => @auth_headers
    puts @response.parsed_body

    test_csv = CSV.parse(@response.parsed_body)

    assert_response :success
    assert master_csv[0] == test_csv[0]
    assert master_csv.length == test_csv.length
  end

  test "shouldn't export without authentication" do
    get '/expenditures/export'

    assert_response :unauthorized
  end
end
