require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:one)
    
    @auth_headers = authenticate_test[:headers]
  end

  test 'should get index with authentication' do
    get images_url, :headers => @auth_headers

    assert_response :success
    assert_not @response.parsed_body.nil?
    assert_not @response.parsed_body['images'].nil?
    assert @response.parsed_body['images'].length == 1
  end

  test "shouldn't get index without authentication" do
    get images_url

    assert_response :unauthorized
  end

  test 'should get show with authentication' do
    get "/images/#{@image.identifier}", :headers => @auth_headers

    assert_response :success
    assert @response.parsed_body['id'] == @image.id
  end

  test "shouldn't get show without authentication" do
    get image_url(@image)

    assert_response :unauthorized
  end

=begin
  test 'should create with authentication' do
    identifier = SecureRandom.uuid
    content = File.open('test/fixtures/files/test.png', 'rb').read

    assert_difference('Image.count', 1) do
      post images_url, :params => { identifier: identifier, image: Base64.encode64(content) }, :headers => @auth_headers, as: :json
    end

    assert_response :success
  end
=end

  test "shouldn't create without authentication" do
    assert_difference('AnalyticEntry.count', 0) do
      post images_url, :params => { identifier: 'blah' }.to_json
    end

    assert_response :unauthorized
  end

  test "shouldn't destroy without authentication" do
    assert_difference('AnalyticEntry.count', 0) do
      delete image_url(@image)
    end

    assert_response :unauthorized
  end

=begin
  test 'should delete with authentication' do
    identifier = SecureRandom.uuid
    content = File.open('test/fixtures/files/test.png', 'rb').read
    post images_url, :params => { identifier: identifier, image: Base64.encode64(content) }, :headers => @auth_headers, as: :json

    image = Image.where( :identifier => identifier ).first

    assert_difference('Image.count', -1) do
      delete image_url(image), :headers => @auth_headers
    end

    assert_response :success
  end
=end
end
