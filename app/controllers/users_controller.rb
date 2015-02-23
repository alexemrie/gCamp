class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    user.save

    redirect_to users_path(user)
    flash[:success] = "User was successfully created"
  end

<<<<<<< HEAD
  def show
    @user = User.find(params[:id])
  end

=======
>>>>>>> master
  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])

    if user.update(user_params)
<<<<<<< HEAD
      redirect_to user_path(user)
      flash[:success] = 'User was successfully updated.'
=======
      redirect_to users_path(user)
      flash[:success] = "User was successfully updated"
>>>>>>> master
    else
      render :edit
    end
  end

<<<<<<< HEAD
=======
  def show
    @user = User.find(params[:id])
  end

>>>>>>> master
  def destroy
    User.destroy(params[:id])

    redirect_to users_path
<<<<<<< HEAD
=======
    flash[:success] = "User was successfully deleted"
>>>>>>> master
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email)
  end


end
