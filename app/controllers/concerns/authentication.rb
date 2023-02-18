module Authentication
    extend ActiveSupport::Concern

    included do
        helper_method :current_user
        helper_method :user_signed_in?
        helper_method :redirect_unauthenticated
    end

    def sign_in(email:, password:)
        puts "Signing in #{email} using '#{password}' as the password"
        user = User.find_by(email: email)
        if user&.authenticate(password)
            reset_session
            session[:current_user_public_id] = user.public_id
            true
        else
            false
        end
    end

    def sign_out
        reset_session
    end

    private

    def current_user
        Current.user ||= User.find_by(public_id: session[:current_user_public_id])
    end

    def user_signed_in?
        current_user.present?
    end

    def redirect_unauthenticated
        redirect_to user_sign_in_path(continue_path: request.path) unless user_signed_in?
    end
end