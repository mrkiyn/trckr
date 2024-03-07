class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_no_of_categories = current_user.categories.count # For Header
    @current_date = Date.today.strftime("%Y-%m-%d") # Current date to check the count of pending tasks that is > current date
    @category = Category.new # For Creation
    @categories = Task.find_by_sql("
      SELECT categories.*, 
        COUNT(tasks.id) FILTER (WHERE tasks.status = 'Pending') AS pending_task_count,
        COUNT(tasks.id) FILTER (WHERE tasks.due_date < '#{@current_date}' AND tasks.status = 'Pending') AS overdue_task_count,
        COUNT(tasks.id) FILTER (WHERE tasks.priority_level = 'High' AND tasks.status = 'Pending') AS high_priority_task_count
      FROM categories
      LEFT JOIN tasks ON categories.id = tasks.category_id
      WHERE categories.user_id = '#{current_user.id}'
      GROUP BY categories.id
      ORDER BY categories.updated_at DESC;
    ")
  end


  def create
    @new_category = current_user.categories.new(category_params)
  
    if @new_category.save
      redirect_to categories_path, notice: "Category was successfully saved."
    else
      redirect_to categories_path, alert: "Category was not saved."
    end
  end


  def update
    @category = current_user.categories.find(params[:id])

    if @category.update(category_params)
      redirect_to category_path(@category), notice: "Category was successfully updated."
    else
      redirect_to category_path(@category), alert: "Category update was unsuccessful."
    end
  end

  def show
    #Primary needs -> esp. for header
    @category = current_user.categories.find(params[:id])
    @tasks_count = @category.tasks.count

    @current_date = Date.today
    @tasks = Task.find_by_sql("
      SELECT *, TO_CHAR(tasks.due_date, 'MM-DD-YYYY') AS formatted_due_date
      FROM tasks
      WHERE category_id = #{@category.id}
      ORDER BY status DESC, formatted_due_date
    ")

    @task = @category.tasks.build  
  end

  def destroy
    @category = current_user.categories.find(params[:id])
    if @category.destroy
      redirect_to categories_path, notice: "Category was removed from the list.", success: true
    else
      redirect_to categories_path, alert: "Something happened. Please try again", success: false
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end
end