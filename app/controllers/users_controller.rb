class UsersController < ApplicationController

  # Require the user is logged in before running any of the following actions
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]

  before_action :correct_user, only: [:edit, :update]

  # User must be an admin to delete users
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    # debugger
    end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      # Send activation email
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account'
      redirect_to root_url
    else
      # Handle an unsuccessful save.
      # Redirect to the 'new' view
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      # Handle an unsuccessful update
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted!'
    redirect_to users_url
  end


  private


    def user_params
      # Require name, only permit the fields we explicitly accept
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end

    # Confirms a logged in user
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = 'Sign in to access this page'
        redirect_to login_url
      end
    end

    # Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Is Admin user?
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end


end
