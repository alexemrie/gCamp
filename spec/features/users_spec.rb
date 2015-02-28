require 'rails_helper'

describe 'managing users' do
  describe "user can add, edit, and destroy tasks with valid data" do
    before :each do
      User.destroy_all
    end

    it "Visits the users page" do
      visit users_path

      expect(page).to have_content "Users"
      expect(page).to have_content "Name"
      expect(page).to have_content "Email"
      expect(page).to have_link "New User"

    end

    it "Successfully creates a new user" do
      visit new_user_path

      expect(page).to have_content "New User"
      expect(page).to have_content "First name"
      expect(page).to have_content "Last name"
      expect(page).to have_content "Email"
      expect(page).to have_link "Cancel"

      fill_in "First name", :with => "Bill"
      fill_in "Last name", :with => "Smith"
      fill_in "Email", :with => "billsmith@example.com"

      click_on "Create User"

      expect(page).to have_content "Bill"
      expect(page).to have_content "Smith"
      expect(page).to have_content "billsmith@example.com"

    end

    it "Errors when create a user without a First name, Last name, Email" do

      visit new_user_path

      click_on "Create User"

      expect(page).to have_content "3 errors prohibited this form from being saved"
      expect(page).to have_content "First name can't be blank"
      expect(page).to have_content "Last name can't be blank"
      expect(page).to have_content "Email can't be blank"


    end

    it "Errors when create a user with same email as existing user" do
      User.create(first_name: "Bill", last_name: "Smith", email: "billsmith@example.com")

      visit new_user_path

      fill_in "First name", :with => "Kevin"
      fill_in "Last name", :with => "Spacey"
      fill_in "Email", :with => "billsmith@example.com"

      click_on "Create User"

      expect(page).to have_content "1 error prohibited this form from being saved"
      expect(page).to have_content "Email has already been taken"


    end

    it "Cancels creating a new user" do
      visit new_user_path

      fill_in "First name", :with => "Kevin"
      fill_in "Last name", :with => "Spacey"
      fill_in "Email", :with => "billsmith@example.com"

      click_on "Cancel"

      expect(page).to_not have_content "Kevin"
      expect(page).to_not have_content "Spacey"
      expect(page).to_not have_content "billsmith@example.com"
    end

    it "Cancels updating a user" do
      user = User.create(first_name: "Grant", last_name: "Smith", email: "icesoccer@gmail.com")

      visit edit_user_path(user)

      fill_in "Email", with: "niceguy11@gmail.com"

      click_on "Cancel"

      expect(page).to_not have_content "niceguy11@gmail.com"
    end


    it "Successfully updates a user" do
      user = User.create(first_name: "Grant", last_name: "Smith", email: "icesoccer@gmail.com")

      visit edit_user_path(user)

      fill_in "Email", with: "niceguy11@gmail.com"

      click_on "Update User"

      expect(page).to have_content "niceguy11@gmail.com"
    end

    it "Successfully destroys a user" do
      user = User.create(first_name: "Grant", last_name: "Smith", email: "icesoccer@gmail.com")
      visit edit_user_path(user)
      click_on "Delete User"
      expect(page).to_not have_content "Grant"
      expect(page).to_not have_content "Smith"
      expect(page).to_not have_content "icesoccer@gmail.com"
    end

    it "Clicks on user name from user index page" do
      User.create(first_name: "Grant", last_name: "Smith", email: "icesoccer@gmail.com")
      visit users_path
      click_on "Grant Smith"
    end
  end
end
