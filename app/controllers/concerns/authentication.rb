module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    helper_method :user_signed_in?
    helper_method :redirect_unauthenticated
  end

  def sign_in(user, options={stay_signed_in: false})
    session[:user_id] = user.id
    user.update(signed_in_at: DateTime.current)
    if options[:stay_signed_in]
      stay_signed_in_token = user.roll_stay_signed_in_token
      cookies.signed[:stay_signed_in] = {
        value: stay_signed_in_token,
        expires: user.stay_signed_in_token_expires_at,
        http_only: true
      }
    end
    user
  end

  def sign_out
    current_user.roll_stay_signed_in_token
    cookies.delete :stay_signed_in
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
    elsif !cookies.signed[:stay_signed_in].blank? # Else if there is a stay signed in cookie, look it up
      user = User.find_by(stay_signed_in_token: cookies.signed[:stay_signed_in])
      if user # If a user has that stay signed in token
        if user.stay_signed_in_token_expired? # But the token is expired!
          # puts "🔥 TOKEN EXPIRED"
          nil
        else # And it is not expired, the user is authenticated. Congrats.
          # puts "🔥 AUTH BY TOKEN"
          sign_in user
        end
      else # No user matches that stay signed in token. Tough luck. No authentication.
        # puts "🔥 NO USER FOUND"
        nil
      end
    end
  end
end