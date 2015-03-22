class PrivateController < ApplicationController
  before_action :ensure_current_user


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
