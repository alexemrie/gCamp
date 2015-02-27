require 'rails_helper'

describe "managing tasks" do
  describe "user can add, edit, and destroy tasks with valid data" do
    before :each do
      Task.destroy_all
    end

    it "Visits the task page" do
      visit tasks_path

      expect(page).to have_content "Tasks"
      expect(page).to have_content "Description"
      expect(page).to have_content "Due Date"
      expect(page).to have_link "New Task"
    end

    it "Successfully creates a new task" do
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

    it "Errors when create task without a description" do
      visit tasks_path
      click_on "New Task"

      fill_in "Due date", :with => "12/05/2015"

      click_on "Create Task"

      expect(page).to have_content "1 error prohibited this form from being saved"
      expect(page).to have_content "Description can't be blank"
    end

    it "Cancels creating a new task" do
      visit new_task_path

      fill_in "Description", with: "Something I do not want to do"

      click_on "Cancel"

      expect(page).to_not have_content "Something I do not want to do"
    end

    it "Cancels updating a task" do
      task = Task.create(description: "Do stuff")
      visit edit_task_path(task)

      fill_in "Description", with: "Do many things"

      click_on "Cancel"

      expect(page).to have_content "Do stuff"
      expect(page).to_not have_content "Do many things"
    end

    it "Successfully updates a task" do
      Task.create(description: "Do Homework", due_date: "12/05/2015")

      visit tasks_path

      click_on "Do Homework"
      click_on "Edit"

      fill_in "Description", with: "Do Algebra"
      fill_in "Due date", with: "12/07/2015"

      click_on "Update Task"

      expect(page).to have_content "Do Algebra"
      expect(page).to have_content "07/12/2015"
      expect(page).to have_content "Task was successfully updated"
    end

    it "Successfully marks a task as complete" do
      task = Task.create(description: "Do Homework", due_date: "12/05/2015", complete: false)

      visit task_path(task)

      click_on "Edit"

      check "Complete"

      click_on "Update Task"
    end

    it "Successfully destroys a task" do
      Task.create(description: "Do Homework", due_date: "12/05/2015")
      visit tasks_path
      click_on "Delete"
      expect(page).to_not have_content "Do Homework"
    end
  end
end
