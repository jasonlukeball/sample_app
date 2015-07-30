class SessionsController < ApplicationController


  def new
  end


  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      # User Exists & Authentication Successful
      # Log the user in & redirect to the user's show page
    else
      # User does not exist or Authentication Failed
      # Show error message
      flash.now[:danger] = 'Invalid Username/Password combination'
      # Go back to login page
      render 'new'
    end
  end


  def destroy
  end


end