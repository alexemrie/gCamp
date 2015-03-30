require 'rails_helper'

describe UsersController do
  before :each do
    @user = create_user(admin: false)
    session[:user_id] = @user.id
  end

  describe 'GET #index' do
    it 'lists all users on the index for logged_in user' do
      get :index
      expect(assigns(:users)).to eq [@user]
    end

    it 'does not display index for non_logged_in user' do
      session.clear
      get :index
      expect(response).to redirect_to signin_path
    end
  end

  describe 'GET #new' do
    it 'creates a new user' do
      get :new
      expect(response).to render_template :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    it 'creates a new user when valid parameters are passed' do

      expect{
        post :create, user: {first_name: "Charlie", last_name: "Chaplin", email: "charlie@gmail.com", password: "password", password_confirmation: "password"}
      }.to change {User.all.count}.by(1)

      expect(flash[:success]).to eq("User was successfully created")
    end

    it 'does not create a new user when invalid parameters are passed' do
      expect{
        post :create, user: {first_name: "Charlie", last_name: "Chaplin", email: nil, password: "password", password_confirmation: "password"}
      }.to_not change {User.all.count}

      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    it 'displays user show page' do
      get :show, id: @user
      expect(assigns(:user)).to eq (@user)
      expect(response).to render_template :show
    end

    it 'does not display user show page for non_logged_in user' do
      session.clear
      get :show, id: @user
      expect(response).to redirect_to signin_path
    end
  end

  describe 'GET #edit' do
    it 'displays user edit page for current_user' do
      get :edit, id: @user
      expect(response).to render_template :edit
      expect(assigns(:user)).to eq (@user)
    end

    it 'does not display user edit page for another user' do
      user = create_user
      get :edit, id: user
      expect(response.status).to eq(404)
    end
  end

  describe 'PATCH #update' do
    it 'updates a user if self' do
      expect{
        patch :update, id: @user, user: {first_name: @user.first_name, last_name: "Chaplin", email: @user.email, password: @user.password, password_confirmation: @user.password}
      }.to change{@user.reload.last_name}.from("John").to("Chaplin")
    end

    it 'does not update not self or admin' do
      user = create_user(email: "different_email@gmail.com")

      expect{
        patch :update, id: user, user: {first_name: user.first_name, last_name: "Chaplin", email: user.email, password: user.password, password_confirmation: user.password}
      }.to_not change{@user.reload.last_name}
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a user and sets all comments to nil' do
      comment = create_comment(user_id: @user.id)

      expect{
        delete :destroy, id: @user.id
      }.to change {User.all.count}.by(-1)

      expect(response).to redirect_to "/"
      expect(flash[:success]).to eq("User was successfully deleted")

      expect(comment.reload.user_id).to eq(nil)
    end

    it 'does not allow a non_admin to delete another user' do
      user = create_user

      expect{
        delete :destroy, id: user.id
      }.to_not change{User.all.count}
    end
  end
end
