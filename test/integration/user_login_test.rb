require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jason)

  end



  test 'login with invalid information' do

    # Go to the login view
    get login_path

    # Test that we're on the correct view
    assert_template 'sessions/new'

    # Simulate submitting the login form
    post login_path session: {email: '', password: ''}

    # Test that we're STILL on the login  view
    assert_template 'sessions/new'

    # We should have a flash message
    assert_not flash.empty?

    # Visit a different page
    get root_path

    # Flash should be empty
    assert flash.empty?

    # Returns true if flash is empty after navigating to a new page

  end

  test 'login with VALID information, followed by logout' do

    # Go to the login view
    get login_path

    # Test that we're on the correct view
    assert_template 'sessions/new'

    # Simulate submitting the login form
    post login_path session: {email: @user.email, password: 'password'}

    # Should return true
    assert is_logged_in?

    # We should be redirected to the user's profile page
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'

    # There should be no links to login now, as we are already logged in
    assert_select "a[href=?]", login_path, count: 0
    # There should be a log out link
    assert_select "a[href=?]", logout_path

    # Logout
    delete logout_path

    # is_logged in should return false
    assert_not is_logged_in?
    # User was redirected to the home page
    assert_redirected_to root_url

    # Simulate a user clicking logout in a second window.
    delete logout_path

    follow_redirect!
    # There should now be a login link
    assert_select "a[href=?]", login_path, count: 1
    # There should NOT be a logout link
    assert_select "a[href=?]", logout_path, count: 0


    # Returns true if all assertions are correct

  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?('')
  end




end
