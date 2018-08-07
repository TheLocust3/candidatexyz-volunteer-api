require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = images(:one)
    
    @auth_headers = authenticate_test[:headers]
  end

  test 'should get index with authentication' do
    get images_url, :headers => @auth_headers

    assert_response :success
  end

  test "shouldn't get index without authentication" do
    get images_url

    assert_response :unauthorized
  end

  test 'should get show without authentication' do
    get image_url(@image)

    assert_response :success
  end

  test "shouldn't create without authentication" do
    assert_difference('AnalyticEntry.count', 0) do
      post images_url, :params => { identifier: 'blah', url: 'test' }.to_json
    end

    assert_response :unauthorized
  end

  # TODO: Actually upload image image. Test deletion
end
