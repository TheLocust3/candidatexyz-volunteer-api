require 'test_helper'

class CommitteesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auth_headers = authenticate_test[:headers]
  end

  test "shouldn't get index without authentication" do
    get committees_url

    assert_response :unauthorized
  end

  # TODO: Index/show/create/update/destroy tests
end
