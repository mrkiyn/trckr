class Category < ApplicationRecord
    validates :name, presence: { message: "Name can't be blank" }
  
    belongs_to :user
    has_many :tasks, dependent: :destroy

    scope :categories_list_with_task_count, -> {
      current_date = Date.today.strftime("%Y-%m-%d")
      select("categories.*, 
              COUNT(tasks.id) FILTER (WHERE tasks.status = 'Pending') AS pending_task_count,
              COUNT(tasks.id) FILTER (WHERE tasks.due_date < '#{current_date}' AND tasks.status = 'Pending') AS overdue_task_count,
              COUNT(tasks.id) FILTER (WHERE tasks.priority_level = 'High' AND tasks.status = 'Pending') AS high_priority_task_count")
        .left_joins(:tasks)
        .group("categories.id, categories.name, categories.updated_at")
        .order("categories.updated_at DESC")
    }
  end