class AccountActivationsController < ApplicationController


  def edit
    user = User.find_by(email: params[:email])
    puts "Found user"
    # if user exists and user is not already activated and the activation_digest matches what we are passing in in params[:id]
    if user && user.authenticated?(:activation, params[:id])
      puts "Passed test"
      # Activate the user
      # Update the user's attributes
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      puts "Attributes activated"
      # Log the user in
      log_in(user)
      # Tell them their account is now active ;)
      flash[:success] = "Welcome to the Sample App #{user.name}!"
      redirect_to user

    else
      # Handle invalid activation link
      flash[:danger] = "Invalid Activation!"
      redirect_to root_url
    end

    # puts params
    # puts "ID: #{params[:id]}"
    # puts "EMAIL: #{params[:email]}"
    # debugger



  end

end
