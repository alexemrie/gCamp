class ProjectsController < PrivateController
  before_action :find_and_set_project, only: [:show, :edit, :update, :destroy]
  before_action :ensure_project_admin_or_member, only: [:show, :update, :destroy]
  before_action :ensure_project_admin_or_owner, only: [:edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      @membership = @project.memberships.create!(user_id: current_user.id, role: "Owner")
      redirect_to project_tasks_path(@project)
      flash[:success] = "Project was successfully created"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to project_path(@project)
      flash[:success] = "Project was successfully updated"
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    @project.destroy
    redirect_to projects_path
    flash[:success] = "Project was successfully deleted"
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def find_and_set_project
    @project = Project.find(params[:id])
  end
end
