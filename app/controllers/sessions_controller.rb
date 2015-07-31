class SessionsController < ApplicationController


  def new
  end


  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # User Exists & Authentication Successful
      # Log the user in & redirect to the user's show page
      # Logic for log_in comes from the SessionsHelper
      log_in user
      redirect_to user
    else
      # User does not exist or Authentication Failed
      # Show error message
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end


  def destroy
  end


end