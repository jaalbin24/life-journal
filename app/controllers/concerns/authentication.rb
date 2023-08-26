module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    helper_method :user_signed_in?
    helper_method :redirect_unauthenticated
  end

  def sign_in(email:, password:, remember_me:)
    user = User.find_by(email: email)
    if user&.authenticate(password)
      reset_session
      session[:user_id] = user.id
      if remember_me
        p "========================"
        p "REMEMBER ME"
        p "========================"
        remember_me_token = user.roll_remember_me_token
        cookies.signed[:remember_me] = {
          value: remember_me_token,
          expires: user.remember_me_token_expires_at,
          secure: Rails.env.production?
        }
      else
        p "========================"
        p "FORGET ME"
        p "========================"
        if user.purge_remember_me_token

        else
          p user.errors.full_messages.inspect
        end
      end
      true
    else
      false
    end
  end

  def sign_out
    current_user.purge_remember_me_token
    cookies.delete :remember_me
    reset_session
  end

  private

  def current_user
    Current.user ||= User.find_by(id: session[:user_id])
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
end