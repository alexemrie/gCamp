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

  def current_user_or_admin(user)
    user == current_user || current_user.admin
  end

  def current_user_should_not_have_access
    if !current_user_or_admin(@user)
      render file: 'public/404.html', status: :not_found, layout: false
    end
  end

end
