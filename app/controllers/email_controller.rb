class EmailController < ApplicationController
  before_action :redirect_unauthenticated!
  before_action :set_user, only: %i[ edit update ]

  def edit
  end
  
  def update
    if @user.update(email_params)
      redirect_to root_path
    else
      render :edit
    end
  end
  
  private
  
  def email_params
    params.require(:user).permit(:email)
  end

  def set_user
    @user = current_user
  end
end
