class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = 'Task was successfully created'
      redirect_to task_path(@task)
    else
      render :new
    end
  end



  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def destroy
    Task.destroy(params[:id])

    redirect_to tasks_path
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to task_path(@task)
      flash[:success] = 'Task was successfully updated.'
    else
      render :edit
    end
  end

  private

  def task_params
    params.require(:task).permit(:description, :complete, :due_date)
  end

end
