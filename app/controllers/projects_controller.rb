class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    project = Project.new(project_params)
    project.save

    redirect_to projects_path(project)
    flash[:success] = "Project was successfully created"
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    project = Project.find(params[:id])

    if project.update(project_params)
      redirect_to project_path(project)
      flash[:success] = "Project was successfully updated"
    else
      render :edit
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def destroy
    Project.destroy(params[:id])

    redirect_to projects_path
    flash[:success] = "Project was successfully deleted"
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end


end