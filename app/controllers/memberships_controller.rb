class MembershipsController < PrivateController

  before_action :find_and_set_project
  before_action :find_and_set_membership, only: [:update, :destroy]
  before_action :ensure_project_member_or_admin
  before_action :verify_at_least_one_owner, only: [:update, :destroy]

  before_action do
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
    if @membership.update(membership_params)
      flash[:success] = "#{@membership.user.full_name} was successfully updated"
      redirect_to project_memberships_path(@membership.project_id)
    else
      @membership = membership
      render :index
    end
  end

  def destroy
    @membership.destroy
    flash[:success] = "#{@membership.user.full_name} was successfully removed"
    if current_user.id == @membership.user_id
      redirect_to projects_path
    else
      redirect_to project_memberships_path(@membership.project_id)
    end
  end

  private

  def membership_params
    params.require(:membership).permit(:role, :user_id, :project_id)
  end

  def find_and_set_project
    @project = Project.find(params[:project_id])
  end

  def find_and_set_membership
    @membership = Membership.find(params[:id])
  end

  def verify_at_least_one_owner
    @membership = Membership.find(params[:id])
    if @membership.role == "Owner" && @project.memberships.where(role: "Owner").count <= 1
      flash[:error] = "Projects must have at least one owner"
      redirect_to project_memberships_path(@membership.project_id)
    end
  end
end
