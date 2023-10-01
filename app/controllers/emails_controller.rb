class EmailsController < ApplicationController
  before_action :redirect_unauthenticated
  before_action :set_user, only: %i[ edit update ]

  def edit
  end
  
  def update
    if @user.update(email_params)
      if @persisted_email == @user.email
        alerts.append Alert::Warning.new(title: "Your email was not changed", body: "Your email is still #{@user.email}").flash
      else
        alerts.append Alert::Success.new(title: "Your email was updated", body: "Your new email is #{@user.email}").flash
      end
      redirect_to @user, status: :see_other
    else
      alerts_now.append Alert::Error.new(title: "Your email was not changed").flash
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
