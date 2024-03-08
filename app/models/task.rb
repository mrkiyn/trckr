class Task < ApplicationRecord
  validates :name, presence: true

  validates :due_date, presence: true
  validates :priority_level, inclusion: { in: ['Low', 'High'] }
  validates :status, inclusion: { in: ['Pending', 'Completed'] }

  validate :due_date_not_in_past

  belongs_to :category

  private

  def due_date_not_in_past
    errors.add(:due_date, "can't be in the past") if due_date && due_date < Date.today
  end
end
