class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def ensure_current_user
    unless current_user
      redirect_to signin_path
      flash[:error] = "You must sign in"
    end
  end

  def current_user
    if session[:user_id].present?
      User.find(session[:user_id])
    end
  end

  helper_method :current_user
end
