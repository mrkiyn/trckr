require "test_helper"

class MainControllerTest < ActionDispatch::IntegrationTest
  test "redirect if not logged in" do
      get root_path
    assert_response :redirect # must be redirected if not logged in
  end
end
