require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

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

end
