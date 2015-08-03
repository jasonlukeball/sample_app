require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user       = users(:jason)
    @other_user = users(:msh)
  end




  test 'should redirect index when not logged in' do
    get :index
    assert_redirected_to login_url



  end



  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should redirect edit when not logged in' do
    get :edit, id: @user.id
    assert_redirected_to login_url
  end

  test 'should NOT redirect edit when logged in' do
    log_in_as(@user)
    get :edit, id: @user.id
    assert_template 'users/edit'
  end

  test 'should redirect patch when not logged in' do
    patch :update, id: @user.id, user: {name: @user.name, email: @user.email}
    assert_redirected_to login_url
  end

  test 'should NOT redirect patch when user is logged in' do
    log_in_as(@user)
    patch :update, id: @user.id, user: {name: @user.name, email: @user.email}
    assert_redirected_to @user
  end

  test 'should redirect edit when logged in as wrong user' do
    # If i am user 1 and i try to edit user 2 etc
    log_in_as(@other_user)
    get :edit, id: @user.id
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    # If i am user 1 and i try to update user 2 etc
    log_in_as(@other_user)
    patch :update, id: @user.id, user: {name: @user.name, email: @user.email}
    assert_redirected_to root_url
  end





end
