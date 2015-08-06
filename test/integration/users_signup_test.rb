require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do

    # Go to sign up path
    get signup_path

    # Successfully loaded sign up page
    assert_response :success

    # Total count of User records in the database
    before_count = User.count

    # Simulate create new user, but with invalid data
    post users_path, user: { name: "", email: "user@invalid", password: "", password_confirmation: "" }

    # Total count of User records in the database
    after_count = User.count

    # Test to see if the total user records is the same
    assert_equal before_count, after_count

    # When the post fails we should have re-rendered the users#new view

    assert_template 'users/new'

    # This will return true if the new user was not successfully saved

  end

  test 'valid signup information' do

    # Go to sign up path
    get signup_path

    assert_difference 'User.count', 1 do
      post users_path, user: { name:                    'Test User',
                               email:                   'test@me.com',
                               password:                '123456',
                               password_confirmation:   '123456' }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to login before activating
    log_in_as(user)
    # Should not be signed in
    assert_not is_logged_in?
    # Try the wrong activation token
    get edit_account_activation_path('wrong token')
    # Should not be signed in
    assert_not is_logged_in?
    # Login with valid token but invalid email address
    get edit_account_activation_path(user.activation_token, email: 'wrong email')
    # Should not be signed in
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    end

end