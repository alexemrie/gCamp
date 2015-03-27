class PrivateController < ApplicationController
  before_action :ensure_logged_in_user

  def ensure_logged_in_user
    if !current_user
      flash[:error] = "You must sign in!"
      session[:return_to] ||= request.url
      redirect_to signin_path
    end
  end

  def current_user_or_admin(user)
    user == current_user || current_user.admin
  end

  def ensure_project_member_or_admin
    if !current_user.admin_or_member?(@project)
      flash[:error] = "You do not have access to that project"
      redirect_to projects_path
    end
  end

  def ensure_project_admin_or_member
    if !current_user.admin_or_member?(@project)
      flash[:error] = "You do not have access to that project"
      redirect_to projects_path
    end
  end

  def ensure_project_admin_or_owner
    if !current_user.admin_or_owner?(@project)
      flash[:error] = 'You do not have access'
      redirect_to projects_path
    end
  end

  def current_user_should_not_have_access
    if !current_user_or_admin(@user)
      render file: 'public/404.html', status: :not_found, layout: false
    end
  end

end
