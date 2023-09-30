require 'rails_helper'

RSpec.describe "Changing a user's email", type: :system do
  describe "", :js do
    let(:user) { create :user }

    before do
      sign_in user
    end
    describe "the user show page" do
      it "links to the edit email page" do
        visit user_path(user)
        click_on "Change email"
        expect(page).to have_current_path(edit_email_path)
      end
    end
    describe "the edit email page" do
      it "shows the user's current email" do
        visit edit_email_path
        expect(page).to have_content "Your current email is #{user.email}"
      end
    end
    describe "the email field" do
      it "is autofocused" do
        visit edit_email_path
        expect(page).to have_focus_on('input[name="user[email]"]')
      end
    end
    describe "the cancel button" do
      it "links to the user show page with an alert" do
        visit edit_email_path
        click_on "Cancel"
        expect(page).to have_current_path(user_path(user, alert: "Your email was not changed"))
      end
    end
    context "after a failed submission" do
      describe "the edit email page" do
        it "shows the user's current email" do
          visit edit_email_path
          expect(page).to have_content "Your current email is #{user.email}"
        end
      end
      describe "the email field" do
        before do
          visit edit_email_path
          fill_in :user_email, with: "new.email@example.com"
          fill_in :user_password_challenge, with: "INCORRECT_PASSWORD"
          click_on "Save"
        end
        it "renders with the submitted email" do
          expect(find_field('user[email]').value).to eq 'new.email@example.com'
        end
        it "is autofocused" do
          expect(page).to have_focus_on('input[name="user[email]"]')
        end
      end
    end
    context "with no password" do
      before do
        visit edit_email_path
        fill_in :user_email, with: "new.email@example.com"
        fill_in :user_password_challenge, with: ""
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
    context "with the wrong password" do
      before do
        visit edit_email_path
        fill_in :user_email, with: "new.email@example.com"
        fill_in :user_password_challenge, with: "Wr0ngP@ssw0rd"
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
    context "with no email" do
      before do
        visit edit_email_path
        fill_in :user_email, with: ""
        fill_in :user_password_challenge, with: "password123"
        click_on "Save"
      end
      it "shows the expected error message" do
        expect(page).to have_content "You'll need an email"
      end
      it "adds the error class to the relevant password elements" do
        expect(page).to have_css("label.error[for='user_email'")
        expect(page).to have_css("input.error[name='user[email]'")
      end
    end
  end
end