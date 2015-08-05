class SessionsController < ApplicationController


  def new
  end


  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # User Exists & Authentication Successful
      # Log the user in & redirect to the user's show page
      # Logic for log_in comes from the SessionsHelper

      if user.activated?
        # User Activated - log them in
       log_in user
       params[:session][:remember_me] == 1 ? remember(user) : forget(user)
        redirect_back_or user
      else
        # Not activated yet
        message = "Account not activated! - "
        message += "Check your email for the activation link"
        flash[:warning] = message
        redirect_to root_url

      end







    else
      # User does not exist or Authentication Failed
      # Show error message
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end


  def destroy
    # Logic for this is in the SessionsHelper
    log_out if logged_in?
    redirect_to root_url
  end


end