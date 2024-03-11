require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "invalid if due date is blank" do
    task = Task.new({name: "Sample", due_date: "", priority_level: "Low", status: "Pending"})
    task.valid?
    assert_not task.errors[:due_date].empty?
  end

  test "invalid if due date is less than today" do
    task = Task.new({name: "Sample", due_date: "2024-03-07", priority_level: "Low", status: "Pending"})
    task.valid?
    assert_not task.errors[:due_date].empty?
  end
end
