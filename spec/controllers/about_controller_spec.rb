require 'rails_helper'

describe AboutController do
  describe "GET #index" do
    it "should render an index view" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns all projects" do
      project = create_project
      get :index
      expect(assigns(:projects)).to eq [project]
    end

    it "assigns all tasks" do
      task = create_task
      get :index
      expect(assigns(:tasks)).to eq [task]
    end

    it "assigns all project members" do
      membership = create_membership
      get :index
      expect(assigns(:project_memberships)).to eq [membership]
    end

    it "assigns all users" do
      user = create_user
      get :index
      expect(assigns(:users)).to eq [user]
    end

    it "assigns all comments" do
      comment = create_comment
      get :index
      expect(assigns(:comments)).to eq [comment]
    end
  end
end
