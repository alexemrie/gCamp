class AuthenticationController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      flash[:success] = "You have successfully signed in"
      redirect_to session[:return_to] || projects_path
    else
      @user = User.new(email: params[:email])
      @user.errors[:base] << "Email / Password combination is invalid"
      render :new
    end
  end

  def destroy
    session.clear
    flash[:success] = "You have successfully signed out"
    redirect_to root_path
  end
end
