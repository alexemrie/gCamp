class UsersController < PrivateController
  before_action :find_and_set_user, only: [:show, :edit, :update, :destroy]
  before_action :current_user_should_not_have_access, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path(@user)
      flash[:success] = "User was successfully created"
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
      flash[:success] = 'User was successfully updated'
    else
      render :edit
    end
  end

  def destroy
    User.destroy(params[:id])

    session.clear
    flash[:success] = "User was successfully deleted"
    redirect_to root_path
  end

  private

  def user_params
    if current_user.admin
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :pivotal_tracker_token, :admin)
    else
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :pivotal_tracker_token)
    end
  end

  def find_and_set_user
    @user = User.find(params[:id])
  end
end
