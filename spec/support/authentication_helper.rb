module AuthenticationHelper
  def sign_in(user = create(:user))
    if defined?(visit) # If this is a system test...
      visit root_path
      fill_in "user_email", with: user.email
      fill_in "user_password", with: "password123"
      click_on "Sign in"
    else # Else this must be a controller test...
      session[:user_id] = user.id
    end
    user
  end
  
  def sign_out
    if defined?(visit) # If this is a system test...
      click_on "Sign out"
    else # Else this must be a controller test...
      session.clear
      Current.user = nil
    end
  end  
end