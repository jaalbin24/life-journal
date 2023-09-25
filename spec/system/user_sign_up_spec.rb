require 'rails_helper'

RSpec.describe 'Signing up a user', type: :system do
  describe "", :js do
    describe "with valid input" do
      it "works" do
        visit root_path
        click_on "Sign up"
        fill_in "user_email", with: "test@example.com"
        fill_in "user_password", with: "P@ssw0rd"
        fill_in "user_password_confirmation", with: "P@ssw0rd"
        click_on "Sign up"
        expect(current_path).to eq root_path
      end
    end
    describe "with no email" do
      before do
        visit new_user_path
        fill_in :user_email, with: ""
        fill_in :user_password, with: "password123"
        fill_in :user_password_confirmation, with: "password123"
        click_on "Sign up"
      end
      it "shows the expected error message" do
        expect(page).to have_content "You'll need an email"
      end
      it "adds the error class to the relevant password elements" do
        expect(page).to have_css("label.error[for='user_email']")
        expect(page).to have_css("input.error[name='user[email]']")
      end
    end
    describe "with no password" do
      before do
        visit new_user_path
        fill_in :user_email, with: "email@example.com"
        fill_in :user_password, with: ""
        fill_in :user_password_confirmation, with: ""
        click_on "Sign up"
      end
      it "shows the expected error message" do
        expect(page).to have_content "Your password can't be blank"
      end
      it "adds the error class to the relevant password elements" do
        expect(page).to have_css("label.error[for='user_password']")
        expect(page).to have_css("input.error[name='user[password]']")
      end
    end
    describe "with a malformed email" do
      before do
        visit new_user_path
        fill_in :user_email, with: "emailexample.com"
        fill_in :user_password, with: "password123"
        fill_in :user_password_confirmation, with: "password123"
        click_on "Sign up"
      end
      it "shows the expected error message" do
        expect(page).to have_content "That's not an email"
      end
      it "adds the error class to the relevant password elements" do
        expect(page).to have_css("label.error[for='user_email']")
        expect(page).to have_css("input.error[name='user[email]']")
      end
    end
    describe "with mismatched password and password confirmation" do
      before do
        visit new_user_path
        fill_in :user_email, with: "email@example.com"
        fill_in :user_password, with: "password123"
        fill_in :user_password_confirmation, with: "password456"
        click_on "Sign up"
      end
      it "shows the expected error message" do
        expect(page).to have_content "The passwords don't match"
      end
      it "adds the error class to the relevant password elements" do
        expect(page).to have_css("label.error[for='user_password_confirmation']")
        expect(page).to have_css("input.error[name='user[password_confirmation]']")
      end
    end
  end
end