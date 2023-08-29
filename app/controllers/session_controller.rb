class SessionController < ApplicationController

  before_action :redirect_unauthenticated, except: [:new, :create]

  # GET /sign_in
  def new
    (redirect_to after_sign_in_path; return) if user_signed_in?
    @user = User.new
    render :sign_in
  end

  # POST /sign_in
  def create
    user = User.find_by(email: user_params[:email])
    if user&.authenticate(user_params[:password])
      reset_session
      sign_in user, stay_signed_in: (params[:stay_signed_in] == '1')
      redirect_to after_sign_in_path
      cookies.delete(:after_sign_in_path)
    else
      @user = User.new(user_params)
      @user.errors.add(:base, "Username or password incorrect")
      render :sign_in
    end
  end

  # DELETE /sign_out
  def delete
    sign_out
    redirect_to sign_in_path
  end

  private

  def user_params
    params.require(:user).permit(
      :password,
      :email
    )
  end

  def after_sign_in_path
    if cookies[:after_sign_in_path].blank?
      root_path
    else
      cookies[:after_sign_in_path]
    end
  end
end
