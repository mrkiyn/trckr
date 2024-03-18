class CategoriesController < ApplicationController
  before_action :find_category, only: [:update, :show, :destroy]

  def index
    @total_no_of_categories = current_user.categories.count 
    @category = current_user.categories.new
    @categories = current_user.categories.categories_list_with_task_count
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
    if @category.update(category_params)
      redirect_to category_path(@category), notice: "Category was successfully updated."
    else
      redirect_to category_path(@category), alert: "Category update was unsuccessful."
    end
  end

  def show
    @tasks_count = @category.tasks.count

    @current_date = Date.today
    @tasks = current_user.tasks.with_formatted_due_date
                               .where(category_id: @category.id)
                               .order(status: :desc, due_date: :desc)
                               
    @task = @category.tasks.build  
  end

  def destroy
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

  def find_category
    @category = current_user.categories.find(params[:id])
  end

end