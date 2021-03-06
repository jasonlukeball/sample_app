class PasswordResetsController < ApplicationController

  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]


  def new

  end



  def create

    @user = User.find_by(email: params[:password_reset][:email].downcase)

    if @user
      # Found a matching email address
      # Create a reset digest for this user
      @user.create_reset_digest
      # Send password reset email
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      # No user found
      flash.now[:danger] = 'Email address not found!'
      render 'new'
    end

  end



  def edit

  end



  def update

    if password_blank?
      # PASSWORD IS BLANK
      flash.now[:danger] = 'Password cannot be blank'
      render 'edit'
    elsif @user.update_attributes(user_params)
      # PASSWORD RESET SUCCESSFUL
      log_in(@user)
      flash[:success] = 'Password updated!'
      redirect_to @user
    else
      # PASSWORD RESET ERROR
      render 'edit'
    end
  end



  private

    # Before filters

    # Gets a user from the database based on their email address
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirm a valid user
    def valid_user
      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end

    # Check expiration of reset token
    def check_expiration
      if @user.password_reset_expired?
        # PASSWORD RESET EXPIRED
        flash[:danger] = 'Password reset has expired'
        redirect_to new_password_reset_url
      end
    end

    def user_params
      # Require name, only permit the fields we explicitly accept
      params.require(:user).permit(:password,:password_confirmation)
    end

    # Returns true if password is blank
    def password_blank?
      params[:user][:password].blank?
    end



end
