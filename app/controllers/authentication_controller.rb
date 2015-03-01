class AuthenticationController < ApplicationController
  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully signed out"
    redirect_to root_path
  end

end
