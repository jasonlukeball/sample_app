require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

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

    # Successfully loaded sign up page
    assert_response :success

    # Total count of User records in the database
    before_count = User.count

    # Simulate create new user, but with invalid data
    post_via_redirect users_path, user: { name: "Test User", email: "test@me.com", password: "123456", password_confirmation: "123456" }

    # Total count of User records in the database
    after_count = User.count

    # Test to see if the total user records is the same
    assert_not_equal before_count, after_count

    # When the post succeeds we should have rendered the users#show view
    # assert_template 'users/show'

    # The user should be logged in is_logged_in?
    # assert is_logged_in?

    # This will return true if the new user WAS successfully saved

  end

end
