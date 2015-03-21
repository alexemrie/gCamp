class PrivateController < ApplicationController
  before_action :ensure_current_user


  def require_membership
    @project = Project.find(params[:id])

    unless @project.users.pluck(:id).include?(current_user.id)
      flash[:error] = "You do not have access to that project"
      redirect_to projects_path
    end
  end

end
