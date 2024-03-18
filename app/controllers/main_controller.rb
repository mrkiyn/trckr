class MainController < ApplicationController
  def home
    @todays_tasks = current_user.tasks.tasks_details.today
    @todays_tasks_count = current_user.tasks.today.count

    @high_priority_tasks = current_user.tasks.tasks_details.high_priority
    @high_priority_task_count = current_user.tasks.high_priority.count

    @pending_task = current_user.tasks.tasks_details.pending
    @pending_task_count = current_user.tasks.pending.count

    @nearest_due_date = current_user.tasks.nearest_due_date  

    @completed_task = current_user.tasks.tasks_details.completed
    @completed_task_count = current_user.tasks.completed.count

    @overdue_tasks = current_user.tasks.tasks_details.overdue
    @overdue_tasks_count = current_user.tasks.overdue.count

    @all_tasks_count = current_user.tasks.count
    @completed_percentage = (@completed_task_count.to_f / @all_tasks_count * 100).round(2)
    
  end

  def tasks

    @pending_task_count = current_user.tasks.pending.count
    @pending_tasks = current_user.tasks.tasks_details.today

    @overdue_tasks_count = current_user.tasks.overdue.count
    @overdue_tasks = current_user.tasks.tasks_details.overdue

    @completed_task_count = current_user.tasks.completed.count
    @completed_task = current_user.tasks.tasks_details.completed
  end

end
