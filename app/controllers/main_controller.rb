class MainController < ApplicationController
  before_action :authenticate_user!
  
  def home
    @user = current_user
    @current_date = Date.today.strftime("%Y-%m-%d")

    @high_priority_task_count = Task.find_by_sql("
      SELECT COUNT(tasks.id) AS high_priority_task_count
      FROM tasks
      INNER JOIN categories ON tasks.category_id = categories.id
      INNER JOIN users ON categories.user_id = users.id
      WHERE users.id = #{current_user.id}
      AND tasks.status = 'Pending'
      AND tasks.priority_level = 'High'
      AND tasks.due_date >= '#{@current_date}'
    ").first.high_priority_task_count

    @high_priority_tasks = Task.find_by_sql("
      SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
      FROM tasks
      INNER JOIN categories ON tasks.category_id = categories.id
      INNER JOIN users ON categories.user_id = users.id
      WHERE users.id = #{current_user.id}
      AND tasks.status = 'Pending'
      AND tasks.priority_level = 'High'
      AND tasks.due_date >= '#{@current_date}'
      ORDER BY tasks.due_date;
    ")

    @todays_tasks_count = Task.find_by_sql(["
    SELECT COUNT(tasks.id) AS todays_tasks_count
    FROM tasks
    INNER JOIN categories ON tasks.category_id = categories.id
    INNER JOIN users ON categories.user_id = users.id
    WHERE users.id = ?
    AND tasks.due_date = ?
  ", current_user.id, @current_date]).first.todays_tasks_count

    @todays_tasks = Task.find_by_sql(["
      SELECT tasks.*, categories.id AS category_id, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
      FROM tasks
      INNER JOIN categories ON tasks.category_id = categories.id
      INNER JOIN users ON categories.user_id = users.id
      WHERE users.id = ?
      AND tasks.due_date = ?
      ORDER BY tasks.priority_level;
    ", current_user.id, @current_date])

   

    @pending_task_count = Task.find_by_sql("
      SELECT COUNT(tasks.id) AS pending_task_count
      FROM tasks
      INNER JOIN categories ON tasks.category_id = categories.id
      INNER JOIN users ON categories.user_id = users.id
      WHERE users.id = #{current_user.id}
      AND tasks.status = 'Pending'
      AND tasks.priority_level != 'High';
    ").first.pending_task_count

    @pending_task = Task.find_by_sql("
    SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
      FROM tasks
      INNER JOIN categories ON tasks.category_id = categories.id
      INNER JOIN users ON categories.user_id = users.id
      WHERE users.id = #{current_user.id}
      AND tasks.status = 'Pending'
      AND tasks.priority_level != 'High';
    ")

    @nearest_due_date = Task.find_by_sql("
      SELECT TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_earliest_due_date, COUNT(tasks.id) AS task_count, categories.id AS category_id, categories.name AS category_name
      FROM tasks
      INNER JOIN categories ON tasks.category_id = categories.id
      INNER JOIN users ON categories.user_id = users.id
      WHERE users.id = #{current_user.id}
      AND tasks.due_date = (
          SELECT MIN(due_date)
          FROM tasks
          WHERE tasks.status = 'Pending'
          AND tasks.due_date >= '#{@current_date}'
      )
      GROUP BY tasks.due_date, categories.id, categories.name;
    ")

    @completed_task_count = Task.find_by_sql("
      SELECT COUNT(tasks.id) AS completed_task_count
      FROM tasks
      INNER JOIN categories ON tasks.category_id = categories.id
      INNER JOIN users ON categories.user_id = users.id
      WHERE users.id = #{current_user.id}
      AND tasks.status = 'Completed';
    ").first.completed_task_count

    @completed_task = Task.find_by_sql("
    SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
    FROM tasks
    INNER JOIN categories ON tasks.category_id = categories.id
    INNER JOIN users ON categories.user_id = users.id
    WHERE users.id = #{current_user.id}
    AND tasks.status = 'Completed';
    ")

    @overdue_tasks_count = Task.find_by_sql(["
    SELECT COUNT(tasks.id) AS todays_tasks_count
    FROM tasks
    INNER JOIN categories ON tasks.category_id = categories.id
    INNER JOIN users ON categories.user_id = users.id
    WHERE users.id = ?
    AND tasks.due_date < ?
    AND tasks.status = 'Pending'
  ", current_user.id, @current_date]).first.todays_tasks_count

    @overdue_tasks = Task.find_by_sql(["
      SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
      FROM tasks
      INNER JOIN categories ON tasks.category_id = categories.id
      INNER JOIN users ON categories.user_id = users.id
      WHERE users.id = ?
      AND tasks.due_date < ?
      AND tasks.status = 'Pending'
      ORDER BY tasks.priority_level;
    ", current_user.id, @current_date])

    @all_tasks_count = Task.find_by_sql("
      SELECT COUNT(tasks.id) AS todays_tasks_count
      FROM tasks
      INNER JOIN categories ON tasks.category_id = categories.id
      INNER JOIN users ON categories.user_id = users.id
      WHERE users.id = #{current_user.id};
    ").first.todays_tasks_count

    
    @completed_percentage = (@completed_task_count.to_f / @all_tasks_count * 100).round(2)
  end

  def tasks
    @current_date = Date.today.strftime("%Y-%m-%d")
  @pending_task_count = Task.find_by_sql([
    "SELECT COUNT(tasks.id) AS pending_task_count
    FROM tasks
    INNER JOIN categories ON tasks.category_id = categories.id
    INNER JOIN users ON categories.user_id = users.id
    WHERE users.id = ?
    AND tasks.status = 'Pending'
    AND tasks.due_date >= ?",
    current_user.id, Date.today
  ]).first.pending_task_count

    @pending_tasks = Task.find_by_sql([
      "SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
      FROM tasks
      INNER JOIN categories ON tasks.category_id = categories.id
      INNER JOIN users ON categories.user_id = users.id
      WHERE users.id = ?
      AND tasks.status = 'Pending'
      AND tasks.due_date >= ?
      ORDER BY tasks.priority_level;",
      current_user.id, Date.today
    ])

    @overdue_tasks_count = Task.find_by_sql(["
      SELECT COUNT(tasks.id) AS todays_tasks_count
      FROM tasks
      INNER JOIN categories ON tasks.category_id = categories.id
      INNER JOIN users ON categories.user_id = users.id
      WHERE users.id = ?
      AND tasks.due_date < ?
      AND tasks.status = 'Pending'
    ", current_user.id, @current_date]).first.todays_tasks_count

      @overdue_tasks = Task.find_by_sql(["
        SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
        FROM tasks
        INNER JOIN categories ON tasks.category_id = categories.id
        INNER JOIN users ON categories.user_id = users.id
        WHERE users.id = ?
        AND tasks.due_date < ?
        AND tasks.status = 'Pending'
        ORDER BY tasks.priority_level;
      ", current_user.id, @current_date])

      @completed_task_count = Task.find_by_sql("
        SELECT COUNT(tasks.id) AS completed_task_count
        FROM tasks
        INNER JOIN categories ON tasks.category_id = categories.id
        INNER JOIN users ON categories.user_id = users.id
        WHERE users.id = #{current_user.id}
        AND tasks.status = 'Completed';
      ").first.completed_task_count

      @completed_task = Task.find_by_sql("
        SELECT tasks.*, categories.name AS category_name, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS updated_due_date
        FROM tasks
        INNER JOIN categories ON tasks.category_id = categories.id
        INNER JOIN users ON categories.user_id = users.id
        WHERE users.id = #{current_user.id}
        AND tasks.status = 'Completed';
      ")
  end


end
