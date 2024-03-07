require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  setup do
    sign_in users(:one)
  end

  test "visiting the index" do
    visit root_path
  end
end
