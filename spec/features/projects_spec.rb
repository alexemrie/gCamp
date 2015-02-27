require 'rails_helper'

describe "managing projects" do
  describe "user can add, edit, and destroy projects with valid data" do
    before :each do
      Task.destroy_all
    end

    it "Visits the project page" do
      visit projects_path

      expect(page).to have_content "Projects"
      expect(page).to have_content "Name"
      expect(page).to have_link "New Project"
    end

    it "Successfully creates a new project" do
      visit projects_path

      click_on "New Project"

      fill_in "Name", :with => "Make stuff"

      click_on "Create Project"

      expect(page).to have_content "Make stuff"

      click_on "Make stuff"

    end

    it "Errors when creates a project without a name" do
      visit new_project_path

      click_on "Create Project"

      expect(page).to have_content "1 error prohibited this form from being saved"
      expect(page).to have_content "Name can't be blank"

    end


    it "Cancels creating a project" do
      visit new_project_path
      fill_in "Name", with: "Something I do not want to do"
      click_on "Cancel"
      expect(page).to_not have_content "Something I do not want to do"
    end

    it "Cancels updating a project" do
      project = Project.create(name: "Do stuff")
      visit edit_project_path(project)

      fill_in "Name", with: "Do many things"

      click_on "Cancel"

      expect(page).to have_content "Do stuff"
      expect(page).to_not have_content "Do many things"
    end

    it "Successfully updates a project" do
      Project.create(name: "Do stuff")

      visit projects_path

      click_on "Do stuff"
      click_on "Edit"

      fill_in "Name", with: "Do Algebra"

      click_on "Update Project"

      expect(page).to have_content "Do Algebra"
    end

    it "Successfully destroys a project" do
      Project.create(name: "Do programming")
      visit projects_path

      click_on "Do programming"
      click_on "Delete"

      expect(page).to_not have_content "Do programming"
    end
  end
end
