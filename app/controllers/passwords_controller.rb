class PasswordsController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_user, only: %i[ edit update ]

  def edit
  end
  
  def update
    @old_digest = @user.password_digest
    if @user.update(password_params)
      if @old_digest == @user.password_digest
        flash[:alerts].append Alert::Warning.new(title: "Your password was not changed").flash
      else
        flash[:alerts].append Alert::Success.new(title: "Your password was changed").flash
      end
      redirect_to @user
    else
      flash.now[:alerts].append Alert::Error.new(title: "Your password was not changed").flash
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
