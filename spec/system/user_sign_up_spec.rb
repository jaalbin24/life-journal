require 'rails_helper'

RSpec.describe 'Signing up a user', type: :system do
  describe "", :js do
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
end