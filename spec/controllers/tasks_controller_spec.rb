require 'rails_helper'

describe TasksController do
  before :each do
    @user = create_user(admin: false)
    session[:user_id] = @user.id
    @project = create_project
    @membership = create_membership(project_id: @project.id, user_id: @user.id, role: "Member")
  end

  describe "POST #create" do
    it 'project members can add tasks to projects' do
      expect{
        post :create, task: {description: "Run around"}, project_id: @project.id
      }.to change{Task.all.count}.by(1)
    end

    it 'non-project members cannot add tasks to projects' do
      session.clear
      user = create_user(admin: false)
      session[:user_id] = user.id

      expect{
        post :create, task: {description: "Run around"}, project_id: @project.id
      }.to_not change{Task.all.count}

      expect(flash[:error]).to eq("You do not have access to that project")
    end
  end
end
