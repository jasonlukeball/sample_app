class PasswordResetsController < ApplicationController


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


end
