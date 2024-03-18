class Task < ApplicationRecord
  validates :name, presence: true
  validates :due_date, presence: true
  validates :priority_level, inclusion: { in: ['Low', 'High'] }
  validates :status, inclusion: { in: ['Pending', 'Completed'] }
  validates :due_date, presence: true

  belongs_to :category

  current_date = Date.today.strftime("%Y-%m-%d")

  scope :with_formatted_due_date, -> {
    select("tasks.*, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS formatted_due_date")
  }

  scope :tasks_details, -> {
    select("tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date")
  }


  scope :today, -> {
    where("tasks.due_date = ?", current_date)
    .order("tasks.priority_level")
  }

  scope :high_priority, -> {
    where(status: 'Pending')
    .where(priority_level: 'High')
    .where("tasks.due_date >= ?", current_date)
    .order("tasks.due_date")
  } 

  scope :pending, -> {
    where(status: 'Pending')
    .where(priority_level: 'Low')
    .where("tasks.due_date >= ?", current_date)
    .order("tasks.due_date")
  } 

  scope :completed, -> {
    where(status: 'Completed')
    .order("tasks.updated_at")
  } 

  scope :overdue, -> {
    where("tasks.due_date < ?", current_date)
    .where(status: 'Pending')
  }
  
  

  scope :nearest_due_date, -> {
    select("TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_earliest_due_date, COUNT(tasks.id) AS task_count, categories.id AS category_id, categories.name AS category_name")
                                          .where("tasks.due_date = (
                                              SELECT MIN(due_date)
                                              FROM tasks
                                              WHERE tasks.status = 'Pending'
                                              AND tasks.due_date >= ?
                                          )", current_date)
                                          .group("tasks.due_date, categories.id, categories.name") 
  }

end