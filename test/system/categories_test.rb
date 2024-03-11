require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  test "Check insertion of Categories Data" do
    sign_in users(:one)
    visit categories_path

    find('button[class="h-full w-full py-4"]').click
    # assert_selector '#addNewCategoryModal', visible: true 
    #Modal must be open after click


    within '#addNewCategoryModal' do
      fill_in "category_name", with: "Sample Name"
      fill_in "category_description", with: "Sample Description"

      click_button "SUBMIT"
    end 

    # assert_selector '#addNewCategoryModal', visible: false 
    #Modal must be close after submission

    #Data must be saved and displayed in the table.
    assert_text "Sample Name"
    assert_text "Sample Description"
  end
end
