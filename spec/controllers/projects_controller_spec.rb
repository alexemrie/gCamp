require 'rails_helper'

describe ProjectsController do
  before :each do
    @user = create_user(admin: false)
    session[:user_id] = @user.id
  end

  describe "GET #index" do
    it "assigns all projects with a title Build Shed" do
      project = create_project(name: "Build Shed")
      membership = Membership.create!(user_id: @user.id, project_id: project.id, role: "Owner")

      get :index

      expect(assigns(:projects)).to eq [project]
    end
  end

  describe 'GET #show' do
    it 'displays the project show page for a project member' do
      project = create_project(name: "Build Shed")
      membership = Membership.create!(user_id: @user.id, project_id: project.id, role: "Owner")

      get :show, id: project.id

      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    it "assigns a new Project object" do
      get :new

      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe "POST #create" do
    describe "on success" do
      it "creates a new project when valid parameters are passed" do

        expect {
          post :create, project: {name: "Build House"}}.to change { Project.all.count}.by(1)

        project = Project.last

        expect(project.name).to eq "Build House"
        expect(flash[:success]).to eq "Project was successfully created"
        expect(response).to redirect_to project_tasks_path(project)
      end
    end

    describe "on failure" do
      it "does not create a new project with invalid parameters" do
        expect {
          post :create, project: {name: nil}}.to_not change { Project.all.count}

          expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    describe "on success" do
      describe "updates a project with valid attributes" do
        it "allows a project owner to update a project" do
          project = create_project(name: "Build Shed")
          membership = Membership.create!(user_id: @user.id, project_id: project.id, role: "Owner")
          expect {
            patch :update, id: project.id, project: {name: "Build Barn"}}.to change {project.reload.name}.from("Build Shed").to("Build Barn")

          expect(flash[:success]).to eq "Project was successfully updated"
          expect(response).to redirect_to project_path(project)
        end

        it 'does not allow a project member to update a project' do
          session.clear
          user = create_user(admin: false)
          session[:user_id] = user.id

          project = create_project
          membership = create_membership(user_id: user.id, project_id: project.id, role: "Member")

          expect {
            patch :update, id: project.id, project: {name: "Build Barn"}}.to_not change {project.reload.name}

          expect(flash[:error]).to eq("You do not have access")
          expect(response).to redirect_to projects_path
        end
      end
    end

    describe "on failure" do
      it "does not update a project with invalid attributes" do
        project = create_project(name: "Build Shed")
        membership = Membership.create!(user_id: @user.id, project_id: project.id, role: "Owner")
        expect {
          patch :update, id: project.id, project: {name: nil}}.to_not change {project.reload.name}

        expect(assigns(:project)).to eq(project)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    describe "deletes a project" do
      it 'allows a project owner to delete a project' do
        project = create_project
        membership = Membership.create!(user_id: @user.id, project_id: project.id, role: "Owner")
        expect {
          delete :destroy, id: project.id
        }.to change { Project.all.count }.by(-1)

        expect(flash[:success]).to eq "Project was successfully deleted"
        expect(response).to redirect_to projects_path
      end

      it 'allows an admin to delete a project' do
        session.clear
        admin_user = create_user(admin: true)
        session[:user_id] = admin_user.id

        project = create_project

        expect {
          delete :destroy, id: project.id
        }.to change { Project.all.count }.by(-1)

        expect(flash[:success]).to eq "Project was successfully deleted"
        expect(response).to redirect_to projects_path
      end

      it 'does not allow a project member to delete a project' do
        project = create_project
        membership = create_membership(project_id: project.id, user_id: @user.id, role: "Member")

        expect {
          delete :destroy, id: project.id
        }.to_not change { Project.all.count }

        expect(flash[:error]).to eq("You do not have access")
        expect(response).to redirect_to projects_path
      end
    end
  end
end
