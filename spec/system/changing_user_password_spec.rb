require 'rails_helper'

RSpec.describe "Changing a user's password", type: :system do
  describe "", :js do
    let(:user) { create :user }

    before do
      sign_in user
    end
    describe "the user show page" do
      it "links to the edit password page" do
        visit user_path(user)
        click_on "Change password"
        expect(page).to have_current_path(edit_password_path)
      end
    end
    describe "the password challenge field" do
      it "is autofocused" do
        visit edit_password_path
        expect(page).to have_focus_on('input[name="user[password_challenge]"]')
      end
    end
    describe "the cancel button" do
      it "links to the user show page" do
        visit edit_password_path
        click_on "Cancel"
        expect(page).to have_current_path(user_path(user))
      end
    end
    context "with no password challenge" do
      before do
        visit edit_password_path
        fill_in :user_password_challenge, with: ""
        fill_in :user_password, with: "NewPassword"
        fill_in :user_password_confirmation, with: "NewPassword"
        click_on "Save"
      end
      it "shows the expected error message" do
        expect(page).to have_content "Your password is required"
      end
      it "adds the error class to the relevant password elements" do
        expect(page).to have_css("label.error[for='user_password_challenge']")
        expect(page).to have_css("input.error[name='user[password_challenge]']")
      end
    end
    context "with the wrong password challenge" do
      before do
        visit edit_password_path
        fill_in :user_password_challenge, with: "WrongPassword"
        fill_in :user_password, with: "NewPassword"
        fill_in :user_password_confirmation, with: "NewPassword"
        click_on "Save"
      end
      it "shows the expected error message" do
        expect(page).to have_content "Incorrect password"
      end
      it "adds the error class to the relevant password elements" do
        expect(page).to have_css("label.error[for='user_password_challenge']")
        expect(page).to have_css("input.error[name='user[password_challenge]']")
      end
    end
    context "with mismatched passwords" do
      before do
        visit edit_password_path
        fill_in :user_password_challenge, with: "password123"
        fill_in :user_password, with: "password.1"
        fill_in :user_password_confirmation, with: "password.2"
        click_on "Save"
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