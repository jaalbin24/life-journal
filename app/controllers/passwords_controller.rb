class PasswordsController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_user, only: %i[ edit update ]

  def edit
  end
  
  def update
    if @user.update(password_params)
      redirect_to @user
    else
      render :edit
    end
  end
  
  private
  
  def password_params
    params.require(:user).permit(
      :password,
      :password_confirmation,
      :password_challenge
    )
  end

  def set_user
    @user = current_user
  end
end
