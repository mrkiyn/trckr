class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_category
  before_action :find_task, only: [:destroy]
  
  def create
    @task = @category.tasks.new(task_params)

    if @task.save
      redirect_to category_path(@category), notice: 'Task was successfully created.'
    else
      redirect_to category_path(@category), alert: 'Task creation failed. Please try again. Due date must me today onwards.'
    end
  end

  def update
    @task = @category.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to category_task_path(@category, @task), notice: "Category was successfully updated."
    else
      redirect_to category_task_path(@category, @task), alert: "Something Happened. Please Try Again"
    end
  end

  def show
    @task = @category.tasks.find(params[:id])
    @task_category = Category.find(@task.category_id)
  end

  def destroy
      @task.destroy
      redirect_to category_path(@category), notice: "Task successfully deleted."
  end


  private

  def task_params
    params.require(:task).permit(:name, :description, :due_date, :priority_level, :status)
  end


  def find_category
    @category = Category.find(params[:category_id])
  end

  def find_task
    @task = @category.tasks.find(params[:id])
  end

end