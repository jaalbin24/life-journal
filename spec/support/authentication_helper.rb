module AuthenticationHelper
  def sign_in(user = create(:user))
    if defined?(visit) # If this is a system test...
      visit root_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "password123"
      click_on "Sign in"
      sleep 2
    else # Else this must be a controller test...
      session[:user_id] = user.id
    end
    user
  end
  
  def sign_out
    if defined?(visit) # If this is a system test...
      click_on "Sign out" 
      sleep 2
    else # Else this must be a controller test...
      session.clear
      Current.user = nil
    end
  end  
end