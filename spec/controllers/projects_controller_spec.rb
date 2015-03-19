require 'rails_helper'

describe ProjectsController do
  before :each do
    user = create_user
    session[:user_id] = user.id
  end

  describe "GET #index" do
    it "assigns all projects with a title Build Shed" do
      project = create_project(name: "Build Shed")
      random = create_project(name: "Random")

      get :index

      expect(assigns(:projects)).to eq [project, random]
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
          post :create, project: {name: "Build Shed"}}.to change { Project.all.count}.by(1)

        project = Project.last
        expect(project.name).to eq "Build Shed"
        expect(flash[:success]).to eq "Project was successfully created"
        expect(response).to redirect_to projects_path(project)
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
      it "updates a project with valid attributes" do
        project = create_project(name: "Build Shed")

        expect {
          patch :update, id: project.id, project: {name: "Build Barn"}}.to change {project.reload.name}.from("Build Shed").to("Build Barn")

        expect(flash[:success]).to eq "Project was successfully updated"
        expect(response).to redirect_to project_path(project)
      end
    end

    describe "on failure" do
      it "does not update a project with invalid attributes" do
        project = create_project(name: "Build Shed")

        expect {
          patch :update, id: project.id, project: {name: nil}}.to_not change {project.reload.name}

        expect(assigns(:project)).to eq(project)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETEE #destroy" do
    it "deletes a project" do
      project = create_project

      expect {
        delete :destroy, id: project.id
      }.to change { Project.all.count }.by(-1)

      expect(flash[:success]).to eq "Project was successfully deleted"
      expect(response).to redirect_to projects_path
    end
  end
end
