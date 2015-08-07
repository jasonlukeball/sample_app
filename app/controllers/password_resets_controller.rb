class PasswordResetsController < ApplicationController

  before_action :get_user, only: [:edit, :update]


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

    if @user.password_reset_expired?
      # PASSWORD RESET EXPIRED
      flash[:danger] = 'Password reset has expired'
      redirect_to new_password_reset_url
    elsif ( params[:user][:password].blank? && params[:user][:password_confirmation].blank? )
      # PASSWORD / PASSWORD CONFIRMATION IS BLANK
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
    # Gets a user from the database based on their email address
    def get_user
      @user = User.find_by(email: params[:email])

      unless @user && @user.activated? && @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end

    end

    def user_params
      # Require name, only permit the fields we explicitly accept
      params.require(:user).permit(:password,:password_confirmation)
    end



end
