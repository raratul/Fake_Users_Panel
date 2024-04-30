require "test_helper"

class FakeusersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get fakeusers_index_url
    assert_response :success
  end
end
