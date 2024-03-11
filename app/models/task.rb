class Task < ApplicationRecord
  validates :name, presence: true
  validates :due_date, presence: true
  validates :priority_level, inclusion: { in: ['Low', 'High'] }
  validates :status, inclusion: { in: ['Pending', 'Completed'] }
  validates :due_date, presence: true

  belongs_to :category

end