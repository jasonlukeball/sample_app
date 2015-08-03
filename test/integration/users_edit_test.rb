require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  # Use a test user
  def setup
    @user = users(:jason)
  end


  test 'edit user with INVALID information' do

    # Login as test user
    log_in_as(@user)

    # Go to the edit user path for the test user
    get edit_user_path(@user)

    # We should be on the user's edit page
    assert_template 'users/edit'

    # Successfully loaded edit user page
    assert_response :success

    # Submit patch with INVALID information
    patch user_path(@user), user: { name: "", email: "user@invalid", password: "", password_confirmation: "" }

    # Since this the patch should have failed, we should still be on the edit path
    assert_template 'users/edit'

  end


  test 'edit user with VALID information with friendly forwarding' do

    # Go to the edit user path for the test user
    get edit_user_path(@user)

    # Login as test user
    log_in_as(@user)

    assert_redirected_to edit_user_path(@user)

    # Submit patch with VALID information
    patch user_path(@user), user: { name: "John Smith", email: "john_smith@example.com", password: "", password_confirmation: "" }

    # There should be a flash message "Profile updated!"
    assert_not flash.empty?

    # Should be redirected to user's show page
    assert_redirected_to @user

    @user.reload

    # Values should be what we expect
    assert_equal @user.name, "John Smith"
    assert_equal @user.email, "john_smith@example.com"
  end


end
