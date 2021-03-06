require 'rails_helper'

feature 'managing users' do
  feature "user can add, edit, and destroy users with valid data" do
    before :each do
      User.destroy_all
      @user = create_user
      login(@user)
    end

    scenario "user can create, read, update, and destroy a user" do
      visit users_path

      expect(page).to have_content "Users"
      expect(page).to have_content "Name"
      expect(page).to have_content "Email"
      expect(page).to have_link "New User"

      visit new_user_path

      expect(page).to have_content "New User"
      expect(page).to have_content "First name"
      expect(page).to have_content "Last name"
      expect(page).to have_content "Email"
      expect(page).to have_content "Email"
      expect(page).to have_content "Password"
      expect(page).to have_content "Password confirmation"

      fill_in "First name", :with => "Bill"
      fill_in "Last name", :with => "Smith"
      fill_in "Email", :with => "billsmith@example.com"
      fill_in "Password", :with => "password123"
      fill_in "Password confirmation", :with => "password123"

      #Create a new user
      click_on "Create User"

      expect(page).to have_content "User was successfully created"
      expect(page).to have_content "Bill"
      expect(page).to have_content "Smith"

      #Update an existing user
      visit edit_user_path(@user)

      fill_in "First name", :with => "Bill"
      fill_in "Last name", :with => "Smith"
      fill_in "Email", :with => "niceguy11@gmail.com"
      fill_in "Password", :with => "password123"
      fill_in "Password confirmation", :with => "password123"
      fill_in "Pivotal tracker token", :with => "lskjdfl;ksajlf"

      click_on "Update User"

      expect(page).to have_content "niceguy11@gmail.com"

      click_on "Edit"

      #Delete a user
      click_on "Delete User"
      expect(current_path).to eql "/"
      expect(page).to_not have_content "Bill"
      expect(page).to_not have_content "Smith"
      expect(page).to_not have_content "niceguy11@gmail.com"
    end

    scenario "Errors when create a user without a First name, Last name, Email" do

      visit new_user_path

      click_on "Create User"

      expect(current_path).to eql '/users'
      expect(page).to have_content "prohibited this form from being saved"
      expect(page).to have_content "First name can't be blank"
      expect(page).to have_content "Last name can't be blank"
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"

    end

    scenario "Errors when create a user with same email as existing user" do

      visit new_user_path

      fill_in "First name", :with => "Bill"
      fill_in "Last name", :with => "Smith"
      fill_in "Email", :with => @user.email
      fill_in "Password", :with => "password123"
      fill_in "Password confirmation", :with => "password123"

      click_on "Create User"

      expect(page).to have_content "1 error prohibited this form from being saved"
      expect(page).to have_content "Email has already been taken"

    end

    scenario "Cancels creating a new user" do
      visit new_user_path

      fill_in "First name", :with => "Bill"
      fill_in "Last name", :with => "Smith"
      fill_in "Email", :with => "billsmith@example.com"
      fill_in "Password", :with => "password123"
      fill_in "Password confirmation", :with => "password123"

      click_on "Cancel"

      expect(page).to_not have_content "Kevin"
      expect(page).to_not have_content "Spacey"
      expect(page).to_not have_content "billsmith@example.com"
    end

    scenario "Cancels updating a user" do
      visit edit_user_path(@user)

      fill_in "Email", with: "niceguy11@gmail.com"

      click_on "Cancel"

      expect(page).to_not have_content "niceguy11@gmail.com"
    end
  end
end
