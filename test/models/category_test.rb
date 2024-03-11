require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "invalid if name is null" do
    category = Category.new(name: "")
    category.valid?
    assert_not category.errors[:name].empty?
  end

  test "valid if description is null" do
    category = Category.new({name: "Sample", description: ""})
    category.valid?
    assert_empty category.errors[:name]
    assert_empty category.errors[:description]
  end
end
