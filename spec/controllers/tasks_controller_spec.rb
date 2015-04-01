require 'rails_helper'

describe TasksController do
  before :each do
    @user = create_user(admin: false)
    session[:user_id] = @user.id
    @project = create_project
    @task = create_task(project_id: @project.id)
  end

  describe 'GET #index' do
    it 'allows project member to view list of task for project' do
      membership = create_membership(project_id: @project.id, user_id: @user.id, role: "Member")

      get :index, project_id: @project.id

      expect(response).to render_template :index
      expect(assigns(:tasks)).to eq [@task]
    end

    it 'does not allow non-members to view tasks index' do
      get :index, project_id: @project.id

      expect(response).to redirect_to projects_path
      expect(flash[:error]).to eq "You do not have access to that project"
    end

    it 'allows admin to view tasks index' do
      session.clear
      user = create_user(admin: true)
      session[:user_id] = user.id

      get :index, project_id: @project.id

      expect(response).to render_template :index
      expect(assigns(:tasks)).to eq [@task]
    end
  end

  describe 'GET #new' do
    it 'assigns a new task object' do
      membership = create_membership(project_id: @project.id, user_id: @user.id, role: "Member")

      get :new, project_id: @project.id

      expect(assigns(:task)).to be_a_new(Task)
    end
  end


  describe "POST #create" do
    it 'project members can add tasks to projects' do
      membership = create_membership(project_id: @project.id, user_id: @user.id, role: "Member")
      expect{
        post :create, task: {description: "Run around"}, project_id: @project.id
      }.to change{Task.all.count}.by(1)

      task = Task.last
      expect(response).to redirect_to project_task_path(@project, task)
      expect(flash[:success]).to eq "Task was successfully created"
    end

    it 'admin can add tasks to projects' do
      session.clear
      user = create_user(admin: true)
      session[:user_id] = user.id

      expect{
        post :create, task: {description: "Run around"}, project_id: @project.id
      }.to change{Task.all.count}.by(1)

      task = Task.last
      expect(response).to redirect_to project_task_path(@project, task)
      expect(flash[:success]).to eq "Task was successfully created"
    end

    it 'non-project members cannot add tasks to projects' do
      session.clear
      user = create_user(admin: false)
      session[:user_id] = user.id

      expect{
        post :create, task: {description: "Run around"}, project_id: @project.id
      }.to_not change{Task.all.count}

      expect(flash[:error]).to eq("You do not have access to that project")
      expect(response).to redirect_to projects_path
    end
  end

  describe 'GET #edit' do
    it 'allows project member to edit tasks' do
      membership = create_membership(project_id: @project.id, user_id: @user.id, role: "Member")

      get :edit, id: @task.id, project_id: @project.id

      expect(assigns(:task)).to eq (@task)
    end

    it 'allows admin to edit tasks' do
      session.clear
      user = create_user(admin: true)
      session[:user_id] = user.id

      get :edit, id: @task.id, project_id: @project.id

      expect(assigns(:task)).to eq (@task)
    end

    it 'does not allow a non-member to edit tasks' do
      get :edit, id: @task.id, project_id: @project.id

      expect(response).to redirect_to projects_path
      expect(flash[:error]).to eq "You do not have access to that project"
    end
  end

  describe 'PATCH #update' do
    it 'allows project member to update tasks' do
      membership = create_membership(project_id: @project.id, user_id: @user.id, role: "Member")

      expect{
        patch :update, id: @task.id, task: {description: "it's Wednesday"}, project_id: @project.id
      }.to change {@task.reload.description}.from("Take out the Dog").to("it's Wednesday")

      expect(response).to redirect_to project_task_path(@project, @task)
      expect(flash[:success]).to eq "Task was successfully updated"      
    end


  end
end
