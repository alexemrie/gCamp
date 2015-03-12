require 'rails_helper'

feature "managing tasks" do
  feature "user can add, edit, and destroy tasks with valid data" do
    before :each do
      login
      Task.destroy_all
    end

    scenario "user can create, read, update, and destroy a task" do

      project = create_project

      visit project_tasks_path(project)

      expect(page).to have_content "Tasks"
      expect(page).to have_content "Description"
      expect(page).to have_content "Due Date"
      expect(page).to have_link "New Task"
      within "ol.breadcrumb" do
        expect(page).to have_link "Projects"
        expect(page).to have_link (project.name)
        expect(page).to have_content "Tasks"
      end

      # Creating a new task
      click_on "New Task"

      expect(page).to have_content "New Task"
      expect(page).to have_content "Description"
      expect(page).to have_content "Due date"
      expect(page).to have_button "Create Task"
      expect(page).to have_link "Cancel"
      within "ol.breadcrumb" do
        expect(page).to have_link "Projects"
        expect(page).to have_link (project.name)
        expect(page).to have_content "Tasks"
        expect(page).to have_content "New Task"
      end

      fill_in "Description", :with => "Wash Dishes"
      fill_in "Due date", :with => "12/05/2015"

      click_on "Create Task"

      #Check flash messages for succesfully created task
      expect(page).to have_content "Task was successfully created"
      expect(page).to have_content "Wash Dishes"
      expect(page).to have_content "05/12/2015"

      #Update an existing task
      click_on "Edit"
      within "ol.breadcrumb" do
        expect(page).to have_link "Projects"
        expect(page).to have_link (project.name)
        expect(page).to have_content "Tasks"
        expect(page).to have_content "Wash Dishes"
        expect(page).to have_content "Edit Task"
      end

      fill_in "Description", with: "Do Algebra"
      fill_in "Due date", with: "12/07/2015"
      check "Complete"

      click_on "Update Task"

      expect(page).to have_content "Do Algebra"
      expect(page).to have_content "07/12/2015"
      expect(page).to have_content "Task was successfully updated"

      visit project_tasks_path(project)

      #Destroy an existing task

      first('.glyphicon-remove').click

      expect(current_path).to eql (project_tasks_path(project))
      expect(page).to_not have_content "Do Algebra"
      expect(page).to have_content "Task was successfully deleted"
    end

    scenario "Errors when create task without a description" do
      project = create_project

      visit new_project_task_path(project)

      fill_in "Due date", :with => "12/05/2015"

      click_on "Create Task"

      expect(page).to have_content "1 error prohibited this form from being saved"
      expect(page).to have_content "Description can't be blank"
    end

    scenario "Cancels creating a new task" do
      project = create_project

      visit new_project_task_path(project)

      fill_in "Description", with: "Something I do not want to do"

      click_on "Cancel"

      expect(page).to_not have_content "Something I do not want to do"
    end
  end
end
