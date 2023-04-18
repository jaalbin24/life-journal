module AuthenticationHelper
  def sign_in(user = create(:user))
    visit root_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_on "Sign in"
    sleep 2
  end
end