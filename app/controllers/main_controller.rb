class MainController < ApplicationController
  before_action :set_date
  def home
    @todays_tasks = current_user.tasks.select("tasks.*, categories.id AS category_id, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date")
                                      # .joins(category: :user)
                                      # .where("users.id = ?", current_user.id)
                                      .where("tasks.due_date = ?", @current_date)
                                      .order("tasks.priority_level")

    # @todays_tasks = Task.find_by_sql(["
    #   SELECT tasks.*, categories.id AS category_id, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = ?
    #   AND tasks.due_date = ?
    #   ORDER BY tasks.priority_level;
    # ", current_user.id, @current_date])                              
                                      
    @todays_tasks_count = current_user.tasks.select("tasks.id")
                                            .joins(category: :user)
                                            .where("tasks.due_date = ?", @current_date)
                                            .count

    # @todays_tasks_count = Task.find_by_sql(["
    #   SELECT COUNT(tasks.id) AS todays_tasks_count
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = ?
    #   AND tasks.due_date = ?
    # ", current_user.id, @current_date]).first.todays_tasks_count    

    @high_priority_tasks = current_user.tasks.select("tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date")
                                              # .joins(category: :user)
                                              # .where("users.id = ?", current_user.id)
                                              .where(status: 'Pending')
                                              .where(priority_level: 'High')
                                              .where("tasks.due_date >= ?", @current_date)
                                              .order("tasks.due_date")

    # @high_priority_tasks = Task.find_by_sql("
    #   SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = #{current_user.id}
    #   AND tasks.status = 'Pending'
    #   AND tasks.priority_level = 'High'
    #   AND tasks.due_date >= '#{@current_date}'
    #   ORDER BY tasks.due_date;
    # ")
    
    @high_priority_task_count = current_user.tasks.select("tasks.id")
                                            # .joins(category: :user)
                                            # .where("users.id = ?", current_user.id)
                                            .where(status: 'Pending')
                                            .where(priority_level: 'High')
                                            .where("tasks.due_date >= ?", @current_date)
                                            .count

    # @high_priority_task_count = Task.find_by_sql("
    #   SELECT COUNT(tasks.id) AS high_priority_task_count
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = #{current_user.id}
    #   AND tasks.status = 'Pending'
    #   AND tasks.priority_level = 'High'
    #   AND tasks.due_date >= '#{@current_date}'
    # ").first.high_priority_task_count

    @pending_task = current_user.tasks.select("tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date")
                                      # .joins(category: :user)
                                      # .where("users.id = ?", current_user.id)
                                      .where(status: 'Pending')
                                      .where(priority_level: 'Low')
                                      .where("tasks.due_date >= ?", @current_date)
                                      .order("tasks.due_date")

    # @pending_task = Task.find_by_sql("
    #   SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = #{current_user.id}
    #   AND tasks.status = 'Pending'
    #   AND tasks.priority_level != 'High';
    # ")

    @pending_task_count = current_user.tasks.select("tasks.id")
                                            # .joins(category: :user)
                                            # .where("users.id = ?", current_user.id)
                                            .where(status: 'Pending')
                                            .where(priority_level: 'Low')
                                            .where("tasks.due_date >= ?", @current_date)
                                            .count

    # @pending_task_count = Task.find_by_sql("
    #   SELECT COUNT(tasks.id) AS pending_task_count
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = #{current_user.id}
    #   AND tasks.status = 'Pending'
    #   AND tasks.priority_level != 'High';
    # ").first.pending_task_count
    
    @nearest_due_date = current_user.tasks.select("TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_earliest_due_date, COUNT(tasks.id) AS task_count, categories.id AS category_id, categories.name AS category_name")
                                          # .joins(category: :user)
                                          # .where("users.id = ?", current_user.id)
                                          .where("tasks.due_date = (
                                              SELECT MIN(due_date)
                                              FROM tasks
                                              WHERE tasks.status = 'Pending'
                                              AND tasks.due_date >= ?
                                          )", @current_date)
                                          .group("tasks.due_date, categories.id, categories.name")        

    # @nearest_due_date = Task.find_by_sql("
    #   SELECT TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_earliest_due_date, COUNT(tasks.id) AS task_count, categories.id AS category_id, categories.name AS category_name
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = #{current_user.id}
    #   AND tasks.due_date = (
    #       SELECT MIN(due_date)
    #       FROM tasks
    #       WHERE tasks.status = 'Pending'
    #       AND tasks.due_date >= '#{@current_date}'
    #   )
    #   GROUP BY tasks.due_date, categories.id, categories.name;
    # ")

    @completed_task_count = current_user.tasks.select("tasks.id")
                                            # .joins(category: :user)
                                            # .where("users.id = ?", current_user.id)
                                            .where(status: 'Completed')
                                            .count

    # @completed_task_count = Task.find_by_sql("
    #   SELECT COUNT(tasks.id) AS completed_task_count
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = #{current_user.id}
    #   AND tasks.status = 'Completed';
    # ").first.completed_task_count

    @completed_task = current_user.tasks.select("tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date")
                                            # .joins(category: :user)
                                            # .where("users.id = ?", current_user.id)
                                            .where(status: 'Completed')
                                            .order("tasks.updated_at")


    # @completed_task = Task.find_by_sql("
    # SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
    # FROM tasks
    # INNER JOIN categories ON tasks.category_id = categories.id
    # INNER JOIN users ON categories.user_id = users.id
    # WHERE users.id = #{current_user.id}
    # AND tasks.status = 'Completed';
    # ")

    @overdue_tasks_count = current_user.tasks.select("tasks.id")
                                            # .joins(category: :user)
                                            # .where("users.id = ?", current_user.id)
                                            .where("tasks.due_date < ?", @current_date)
                                            .where(status: 'Pending')
                                            .count


    #   @overdue_tasks_count = Task.find_by_sql(["
    #   SELECT COUNT(tasks.id) AS todays_tasks_count
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = ?
    #   AND tasks.due_date < ?
    #   AND tasks.status = 'Pending'
    # ", current_user.id, @current_date]).first.todays_tasks_count

    @overdue_tasks = current_user.tasks.select("tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date")
                                            # .joins(category: :user)
                                            # .where("users.id = ?", current_user.id)
                                            .where("tasks.due_date < ?", @current_date)
                                            .where(status: 'Pending')
                                            

    # @overdue_tasks = Task.find_by_sql(["
    #   SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = ?
    #   AND tasks.due_date < ?
    #   AND tasks.status = 'Pending'
    #   ORDER BY tasks.priority_level;
    # ", current_user.id, @current_date])

    @all_tasks_count = current_user.tasks.joins(category: :user)
                                            .where("users.id = ?", current_user.id)
                                            .count

    # @all_tasks_count = Task.find_by_sql("
    #   SELECT COUNT(tasks.id) AS todays_tasks_count
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = #{current_user.id};
    # ").first.todays_tasks_count
    
    @completed_percentage = (@completed_task_count.to_f / @all_tasks_count * 100).round(2)
    

  end

  def tasks

    @pending_task_count = current_user.tasks.select("tasks.id")
                                            # .joins(category: :user)
                                            # .where("users.id = ?", current_user.id)
                                            .where(status: 'Pending')
                                            .where(priority_level: 'Low')
                                            .where("tasks.due_date >= ?", @current_date)
                                            .count

    # @pending_task_count = Task.find_by_sql([
    #   "SELECT COUNT(tasks.id) AS pending_task_count
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = ?
    #   AND tasks.status = 'Pending'
    #   AND tasks.due_date >= ?",
    #   current_user.id, Date.today
    # ]).first.pending_task_count

    @pending_tasks = current_user.tasks.select("tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date")
                                              # .joins(category: :user)
                                              # .where("users.id = ?", current_user.id)
                                              .where(status: 'Pending')
                                              .where(priority_level: 'Low')
                                              .where("tasks.due_date >= ?", @current_date)
                                              .order("tasks.due_date")

    # @pending_tasks = Task.find_by_sql([
    #   "SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = ?
    #   AND tasks.status = 'Pending'
    #   AND tasks.due_date >= ?
    #   ORDER BY tasks.priority_level;",
    #   current_user.id, Date.today
    # ])

    @overdue_tasks_count = current_user.tasks.select("tasks.id")
                                              # .joins(category: :user)
                                              # .where("users.id = ?", current_user.id)
                                              .where("tasks.due_date < ?", @current_date)
                                              .where(status: 'Pending')
                                              .count


      #   @overdue_tasks_count = Task.find_by_sql(["
      #   SELECT COUNT(tasks.id) AS todays_tasks_count
      #   FROM tasks
      #   INNER JOIN categories ON tasks.category_id = categories.id
      #   INNER JOIN users ON categories.user_id = users.id
      #   WHERE users.id = ?
      #   AND tasks.due_date < ?
      #   AND tasks.status = 'Pending'
      # ", current_user.id, @current_date]).first.todays_tasks_count

    @overdue_tasks = current_user.tasks.select("tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date")
                                            # .joins(category: :user)
                                            # .where("users.id = ?", current_user.id)
                                            .where("tasks.due_date < ?", @current_date)
                                            .where(status: 'Pending')
                                            

    # @overdue_tasks = Task.find_by_sql(["
    #   SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = ?
    #   AND tasks.due_date < ?
    #   AND tasks.status = 'Pending'
    #   ORDER BY tasks.priority_level;
    # ", current_user.id, @current_date])

    @completed_task_count = current_user.tasks.select("tasks.id")
                                            # .joins(category: :user)
                                            # .where("users.id = ?", current_user.id)
                                            .where(status: 'Completed')
                                            .count

    # @completed_task_count = Task.find_by_sql("
    #   SELECT COUNT(tasks.id) AS completed_task_count
    #   FROM tasks
    #   INNER JOIN categories ON tasks.category_id = categories.id
    #   INNER JOIN users ON categories.user_id = users.id
    #   WHERE users.id = #{current_user.id}
    #   AND tasks.status = 'Completed';
    # ").first.completed_task_count

    @completed_task = current_user.tasks.select("tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date")
                                            # .joins(category: :user)
                                            # .where("users.id = ?", current_user.id)
                                            .where(status: 'Completed')
                                            .order("tasks.updated_at")


    # @completed_task = Task.find_by_sql("
    # SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
    # FROM tasks
    # INNER JOIN categories ON tasks.category_id = categories.id
    # INNER JOIN users ON categories.user_id = users.id
    # WHERE users.id = #{current_user.id}
    # AND tasks.status = 'Completed';
    # ")
  end

  private

  def set_date
    @current_date = Date.today.strftime("%Y-%m-%d")
  end

end
