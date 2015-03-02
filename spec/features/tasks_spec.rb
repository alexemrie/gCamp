require 'rails_helper'

feature "managing tasks" do
  feature "user can add, edit, and destroy tasks with valid data" do
    before :each do
      login
      Task.destroy_all
    end

    scenario "Visits the task page" do
      visit tasks_path

      expect(page).to have_content "Tasks"
      expect(page).to have_content "Description"
      expect(page).to have_content "Due Date"
      expect(page).to have_link "New Task"
    end

    scenario "Successfully creates a new task" do
      visit tasks_path
      click_on "New Task"

      expect(page).to have_link "Tasks"
      expect(page).to have_content "New Task"
      expect(page).to have_content "Description"
      expect(page).to have_content "Due date"
      expect(page).to have_button "Create Task"
      expect(page).to have_link "Cancel"

      fill_in "Description", :with => "Wash Dishes"
      fill_in "Due date", :with => "12/05/2015"

      click_on "Create Task"

      expect(page).to have_content "Task was successfully created"
      expect(page).to have_content "Wash Dishes"
      expect(page).to have_content "05/12/2015"
    end

    scenario "Errors when create task without a description" do
      visit new_task_path

      fill_in "Due date", :with => "12/05/2015"

      click_on "Create Task"

      expect(page).to have_content "1 error prohibited this form from being saved"
      expect(page).to have_content "Description can't be blank"
    end

    scenario "Cancels creating a new task" do
      visit new_task_path

      fill_in "Description", with: "Something I do not want to do"

      click_on "Cancel"

      expect(page).to_not have_content "Something I do not want to do"
    end

    scenario "Cancels updating a task" do
      @task = create_task

      visit tasks_path
      click_on @task.description
      click_on "Edit"

      fill_in "Description", with: "Do many things"

      click_on "Cancel"

      expect(page).to have_content(@task.description)
      expect(page).to have_content(@task.due_date)
      expect(page).to_not have_content "Do many things"
    end

    scenario "Successfully updates a task" do
      @task = create_task
      visit edit_task_path(@task)

      fill_in "Description", with: "Do Algebra"
      fill_in "Due date", with: "12/07/2015"

      click_on "Update Task"

      expect(page).to have_content "Do Algebra"
      expect(page).to have_content "07/12/2015"
      expect(page).to have_content "Task was successfully updated"
    end

    scenario "Successfully marks a task as complete" do
      @task = create_task
      visit edit_task_path(@task)
      check "Complete"
      click_on "Update Task"

      expect(page).to have_content "Task was successfully updated"
    end

    scenario "Successfully destroys a task" do
      @task = create_task
      visit tasks_path
      click_on "Delete"
      expect(page).to_not have_content(@task.description)
    end
  end
end
