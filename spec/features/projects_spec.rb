require 'rails_helper'

feature "managing projects" do
  feature "user can add, edit, and destroy projects with valid data" do

    before :each do
      login
      Project.destroy_all
    end

    scenario "user can create, read, update, and destroy a project" do

      visit projects_path

      expect(page).to have_content "Projects"
      expect(page).to have_content "Name"
      expect(page).to have_link "New Project"

      #Create a new project

      within '.page-header' do
        click_on "New Project"
      end

      expect(current_path).to eql "/projects/new"

      within "ol.breadcrumb" do
        expect(page).to have_content "Projects"
        expect(page).to have_content "New Project"
      end

      fill_in "Name", :with => "Do Awesome Things"

      click_on "Create Project"
      expect(page).to have_content "Do Awesome Things"
      expect(page).to have_content "Project was successfully created"

      #Edit a project
      visit projects_path

      within "table" do
        click_on "Do Awesome Things"
      end

      click_on "Edit"

      within "ol.breadcrumb" do
        expect(page).to have_content "Projects"
        expect(page).to have_content "Do Awesome Things"
        expect(page).to have_content "Edit"
      end

      fill_in "Name", with: "Do Algebra"

      click_on "Update Project"

      expect(page).to have_content "Do Algebra"
      expect(page).to have_content "Project was successfully updated"

      #Destroy a project
      click_on "Delete"
      expect(page).to_not have_content "Do Algebra"
      expect(current_path).to eql "/projects"
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

  end
end
