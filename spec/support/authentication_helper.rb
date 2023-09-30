module AuthenticationHelper
  def sign_in(user = create(:user))
    if defined?(visit) # If this is a system test...
      visit root_path
      find("input#user_email").set user.email
      find("input#user_password").set "password123"
      find("input[value='Sign in']").click
      wait_until { page.has_content?("Sign out") }
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