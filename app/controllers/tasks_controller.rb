class TasksController < PrivateController

  before_action do
    @project = Project.find(params[:project_id])
  end

  def index
    @tasks = @project.tasks
  end

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.new(task_params)
    if @task.save
      flash[:success] = 'Task was successfully created'
      redirect_to project_task_path(@project, @task)
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
    @comments = Comment.all
    @comment = Comment.new
  end

  def edit
    @task = @project.tasks.find(params[:id])
  end

  def update
    @task = @project.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to project_task_path(@project, @task)

      flash[:success] = 'Task was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @task = @project.tasks.find(params[:id])
    @task.destroy
    flash[:success] = 'Task was successfully deleted'
    redirect_to project_tasks_path(@project)
  end

  private

  def task_params
    params.require(:task).permit(:description, :complete, :due_date)
  end

end
