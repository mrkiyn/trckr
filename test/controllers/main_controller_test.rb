require "test_helper"

class MainControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:regular)
  end

  test "redirect if not logged in" do
    sign_out :user 
    get root_path
    assert_response :redirect
  end
end
