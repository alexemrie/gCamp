class ProjectsController < PrivateController
  before_action :require_membership, only: [:show, :edit, :update, :destroy]
  before_action :require_ownership, only: [:edit, :update, :destroy]

  def index
    @projects = current_user.projects.all
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
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      redirect_to project_path(@project)
      flash[:success] = "Project was successfully updated"
    else
      render :edit
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def destroy
    Project.destroy(params[:id])

    redirect_to projects_path
    flash[:success] = "Project was successfully deleted"
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def require_membership
    @project = Project.find(params[:id])

    unless @project.users.pluck(:id).include?(current_user.id)
      flash[:error] = "You do not have access to that project"
      redirect_to projects_path
    end
  end
  
  def require_ownership
    @project = Project.find(params[:id])

    unless @project.memberships.where(user_id: current_user.id).pluck(:role)==["Owner"]
      flash[:error] = "You do not have access"
      redirect_to project_path(@project)
    end
  end
end
