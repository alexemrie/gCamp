require 'rails_helper'

feature "managing projects" do
  feature "user can add, edit, and destroy projects with valid data" do

    before :each do
      login
      Project.destroy_all
    end

    scenario "Visits the project page" do
      visit projects_path

      expect(page).to have_content "Projects"
      expect(page).to have_content "Name"
      expect(page).to have_link "New Project"
    end

    scenario "Successfully creates a new project" do
      visit projects_path

      click_on "New Project"

      fill_in "Name", :with => "Do Awesome Things"

      click_on "Create Project"

      expect(page).to have_content("Do Awesome Things")

      click_on "Do Awesome Things"

    end

    scenario "Errors when creates a project without a name" do
      visit new_project_path

      click_on "Create Project"

      expect(page).to have_content "1 error prohibited this form from being saved"
      expect(page).to have_content "Name can't be blank"

    end


    scenario "Cancels creating a project" do
      visit new_project_path
      fill_in "Name", :with => "Not Gonna Happen"
      click_on "Cancel"
      expect(page).to_not have_content("Not Gonna Happen")
    end

    scenario "Cancels updating a project" do
      @project = create_project
      visit edit_project_path(@project)
      fill_in "Name", with: "Do many things"

      click_on "Cancel"

      expect(page).to have_content(@project.name)
      expect(page).to_not have_content "Do many things"
    end

    scenario "Successfully updates a project" do
      @project = create_project

      visit projects_path

      click_on @project.name
      click_on "Edit"

      fill_in "Name", with: "Do Algebra"

      click_on "Update Project"

      expect(page).to have_content "Do Algebra"
    end

    it "Successfully destroys a project" do
      @project = create_project
      visit project_path(@project)
      
      click_on "Delete"

      expect(page).to_not have_content(@project.name)
    end
  end
end
