class EmailsController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_user, only: %i[ edit update ]

  def edit
  end
  
  def update
    if @user.update(email_params)
      redirect_to @user, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end
  

  def email_params
    params.require(:user).permit(
      :email,
      :password_challenge
    )
  end

  def set_user
    @user = current_user
    @persisted_email = @user.email
  end
end
