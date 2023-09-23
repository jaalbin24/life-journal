class UsersController < ApplicationController
  before_action :redirect_unauthenticated, except: [:new, :create]
  before_action :set_user
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    case tab
    when 0

    else
      @tab = :account
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to after_sign_up_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to tab_user_path(@user, :account) }
      else
        @tab = :account
        format.html { render :show }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
    end
  end

  private
  
  def tab
    params[:tab] || :account
  end

  def set_user
    @user = current_user
  end

  def after_sign_up_path
    root_path
  end

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :password_challenge
    )
  end
end
