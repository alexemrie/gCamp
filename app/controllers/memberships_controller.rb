class MembershipsController < PrivateController
  before_action only: [:edit, :update, :destroy] do
    @project = Project.find(params[:project_id])

    unless @project.memberships.where(user_id: current_user.id).pluck(:role)==["Owner"]
      flash[:error] = "You do not have access"
      redirect_to project_path(@project)
    end
  end

  before_action do
    @project = Project.find(params[:project_id])

    unless @project.users.pluck(:id).include?(current_user.id)
      flash[:error] = "You do not have access to that project"
      redirect_to projects_path
    end
  end

  def index
    @membership = @project.memberships.new
  end

  def create
    membership = @project.memberships.new(membership_params)
    if membership.save
      flash[:success] = "#{membership.user.full_name} was successfully added"
      redirect_to project_memberships_path(membership.project_id)
    else
      @membership = membership
      render :index
    end
  end

  def update
    membership = Membership.find(params[:id])
    if membership.update(membership_params)
      flash[:success] = "#{membership.user.full_name} was successfully updated"
      redirect_to project_memberships_path(membership.project_id)
    else
      @membership = membership
      render :index
    end
  end

  def destroy
    membership = Membership.find(params[:id])
    membership.destroy
    flash[:success] = "#{membership.user.full_name} was successfully removed"
    if current_user.id == membership.user_id
      redirect_to projects_path
    else
      redirect_to project_memberships_path(membership.project_id)
    end
  end

  private


  def membership_params
    params.require(:membership).permit(:role, :user_id, :project_id)
  end

end
