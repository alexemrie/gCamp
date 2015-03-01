class AuthenticationController < ApplicationController
  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully signed out"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])

    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      flash[:success] = "You have successfully signed in"
      redirect_to root_path
    else
      @user = User.new(email: params[:email])
      @user.errors[:base] << "Email / Password combination is invalid"
      render :new
    end
  end
end
