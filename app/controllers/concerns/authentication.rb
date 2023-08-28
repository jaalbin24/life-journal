module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    helper_method :user_signed_in?
    helper_method :redirect_unauthenticated
  end

  def sign_in(user, opts={remember_me: false})
    session[:user_id] = user.id
    if opts[:remember_me]
      remember_me_token = user.roll_remember_me_token
      cookies.signed[:remember_me] = {
        value: remember_me_token,
        expires: user.remember_me_token_expires_at,
        http_only: true,
        secure: Rails.env.production?
      }
    end
    user
  end

  def sign_out
    current_user.roll_remember_me_token
    cookies.delete :remember_me
    reset_session
  end

  private

  def current_user
    Current.user ||= set_current_user
  end

  def user_signed_in?
    current_user.present?
  end

  def redirect_unauthenticated
    unless user_signed_in?
      cookies[:after_sign_in_path] = request.path
      redirect_to sign_in_path
    end
  end

  def set_current_user
    if !session[:user_id].blank? # If the session cookie has a user id stored already, that's your user
      # puts "🔥 AUTH BY SESSION"
      user = User.find_by(id: session[:user_id])
    elsif !cookies.signed[:remember_me].blank? # Else if there is a remember me cookie, look it up
      user = User.find_by(remember_me_token: cookies.signed[:remember_me])
      if user # If a user has that remember me token
        if user.remember_me_token_expired? # But the token is expired!
          # puts "🔥 TOKEN EXPIRED"
          nil
        else # And it is not expired, the user is authenticated. Congrats.
          # puts "🔥 AUTH BY TOKEN"
          sign_in user
        end
      else # No user matches that remember me token. Tough luck. No authentication.
        # puts "🔥 NO USER FOUND"
        nil
      end
    end
  end
end