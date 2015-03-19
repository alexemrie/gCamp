require 'rails_helper'

describe AuthenticationController do
  describe 'GET #new' do
    it "should render a new view" do
      get :new
      expect(response).to render_template(:new)
    end

    it "assigns a new user object" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    it "authenticates a user when valid parameters are passed" do
      user = create_user(password: "password", password_confirmation: "password")



      post :create, user: { first_name: user.first_name, last_name: user.last_name, email: user.email, password: "password",
           password_confirmation: "password"}

      expect(session[:user_id]).to eq user.id



    end
  end
end
