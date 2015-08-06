class AccountActivationsController < ApplicationController


  def edit
    user = User.find_by(email: params[:email])

    # if user exists and user is not already activated and the activation_digest matches what we are passing in in params[:id]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # Activate the user
      # Update the user's attributes
      user.activate
      log_in(user)
      flash[:success] = "Welcome to the Sample App #{user.name}!"
      redirect_to user

    else
      # Handle invalid activation link
      flash[:danger] = "Invalid Activation!"
      redirect_to root_url
    end

  end

end
