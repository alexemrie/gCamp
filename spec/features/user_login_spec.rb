require 'rails_helper'

feature "Logging in users" do
  feature "Signup" do
    scenario "User can Sign Up" do
      visit root_path

      expect(page).to have_content("Sign Up")
      expect(page).to have_content("Sign In")

      within "footer" do
        expect(page).to have_content("About")
        expect(page).to have_content("Terms")
        expect(page).to have_content("FAQ")
        expect(page).to_not have_content("Tasks")
        expect(page).to_not have_content("Users")
        expect(page).to_not have_content("Projects")
      end

      click_on "Sign Up"


      fill_in "First name", with: "Crazy"
      fill_in "Last name", with: "John"
      fill_in "Email", with: "crazyjohn@example.com"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      within "form" do
        click_on "Sign Up"
      end

      expect(current_path).to eq '/'
      expect(page).to have_content("You have successfully signed up")

      within "footer" do
        expect(page).to have_content("About")
        expect(page).to have_content("Terms")
        expect(page).to have_content("FAQ")
        expect(page).to have_content("Tasks")
        expect(page).to have_content("Users")
        expect(page).to have_content("Projects")
      end

      within "nav" do
        expect(page).to have_content("Sign Out")
        expect(page).to have_content("Crazy John")
      end
    end

    scenario "Sign up error messages display properly" do
      visit signup_path

      within "form" do
        click_on "Sign Up"
      end

      expect(page).to have_content("Password can't be blank")
      expect(page).to have_content("Password confirmation can't be blank")
      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name can't be blank")
      expect(page).to have_content("Email can't be blank")
    end

    scenario "User can signout" do
      @user = create_user
      login(@user)

      click_on "Sign Out"

      expect(current_path).to eql '/'
      expect(page).to have_content("You have successfully signed out")

      within "nav" do
        expect(page).to_not have_content("Sign Out")
        expect(page).to_not have_content("Crazy John")
        expect(page).to have_content("Sign Up")
        expect(page).to have_content("Sign In")
      end

      within "footer" do
        expect(page).to have_content("About")
        expect(page).to have_content("Terms")
        expect(page).to have_content("FAQ")
        expect(page).to_not have_content("Tasks")
        expect(page).to_not have_content("Users")
        expect(page).to_not have_content("Projects")
      end
    end


    scenario "User can sign-in" do
      @user = create_user

      visit root_path

      click_on "Sign In"

      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      within "form" do
        click_on "Sign In"
      end

      expect(current_path).to eql '/'
      expect(page).to have_content 'You have successfully signed in'
    end

    scenario "Redirects to Sign In Page when not signed in" do
      visit projects_path

      expect(current_path).to eq '/signin'
    end

    scenario "User signs in with wrong information" do
      visit signin_path

      within "form" do
        click_on "Sign In"
      end

      expect(page).to have_content("Email / Password combination is invalid") 
    end
  end
end
