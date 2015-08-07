require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:jason)
  end


  test 'password resets' do

    # Go to password reset page
    get new_password_reset_url
    # Should see the password_resets new template
    assert_template 'password_resets/new'

    # Submit password reset request with invalid email address
    # ----------------------------------------------------
    post password_resets_path, password_reset: { email: 'wrong@example.com'}
    # Should see a flash message that the email does not exist
    assert_not flash.empty?
    # Should still be o the new password reset page
    assert_template 'password_resets/new'

    # Submit password reset request with VALID email address
    # ----------------------------------------------------
    post password_resets_path, password_reset: { email: @user.email }
    # Should have been sent the password_reset email
    assert_equal 1, ActionMailer::Base.deliveries.size

    # the reset digest for @user should be updated
    assert_not_equal @user.reset_digest, @user.reload.reset_digest

    # Should see a flash message that the password_reset email has been sent
    assert_not flash.empty?
    # Should have been redirected to root_url
    assert_redirected_to root_url

    user = assigns(:user)

    # Submit password reset
    # ----------------------------------------------------

    # Wrong email
    get edit_password_reset_path(user.reset_token, email: 'wrong@example.com')
    # Should have been redirected to root_url
    assert_redirected_to root_url

    # Inactive user
    # Make user inactive
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    # Should have been redirected to root_url
    assert_redirected_to root_url

    # Make user active again
    user.toggle!(:activated)

    # Right email, wrong token
    get edit_password_reset_path('not_a_token', email: user.email)
    # Should have been redirected to root_url
    assert_redirected_to root_url

    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    # Should now be on the edit password view
    assert_template 'password_resets/edit'
    # Check that the 'hidden email address field' is present
    assert_select "input[name=email][type=hidden][value=?]", user.email


      # Submitted with invalid password & password_confirmation
      patch password_reset_path(user.reset_token), email:  user.email, user: { password: 'password', password_confirmation: 'password1' }
      # Should see a div with id 'error_explanations' (validation failed)
      assert_select "div#error_explanations"
      # Should still be on the edit password page
      assert_template 'password_resets/edit'

      # Submitted with blank password
      patch password_reset_path(user.reset_token), email:  user.email, user: { password: '', password_confirmation: 'password' }
      # Should see a flash message that password cannot be blank or is invalid
      assert_not flash.empty?
      # Should still be on the edit password page
      assert_template 'password_resets/edit'

      # Submitted with VALID password &  password confirmation
      patch password_reset_path(user.reset_token), email:  user.email, user: { password: 'password', password_confirmation: 'password' }
      follow_redirect!
      # Should be logged in
      is_logged_in?
      # Should be a flash message saying password has been reset
      assert_not flash.empty?
      # Should be looking at their profile page
      assert_template 'users/show'

  end


end
