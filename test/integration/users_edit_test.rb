require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  # Use a test user
  def setup
    @user = users(:jason)
  end


  test 'edit user with INVALID information' do

    # Go to the edit user path for the test user
    get edit_user_path(@user)

    # Successfully loaded edit user page
    assert_response :success

    # Submit patch with INVALID information
    patch user_path(@user), user: { name: "", email: "user@invalid", password: "", password_confirmation: "" }

    # Since this the patch should have failed, we should still be on the edit path
    assert_template 'users/edit'

  end


  test 'edit user with VALID information' do

    # Go to the edit user path for the test user
    get edit_user_path(@user)

    # Successfully loaded edit user page
    assert_response :success

    # Submit patch with INVALID information
    patch user_path(@user), user: { name: "John Smith", email: "john_smith@example.com", password: "password", password_confirmation: "password" }

    # Since this the patch should have failed, we should still be on the edit path
    assert_template 'users/show'

  end


end
