require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  setup do
    sign_in users(:iyan)
  end

  test "visiting the index" do
    visit root_path
  end
end
