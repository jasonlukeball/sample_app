require 'test_helper'

class UsersIndexTestTest < ActionDispatch::IntegrationTest

  # Use a test user
  def setup
    @user = users(:jason)
  end


  test 'index including pagination' do

    # Login as test user
    log_in_as(@user)

    # Go to users index
    get users_path
    assert_template 'users/index'

    # Pagination should be working
    assert_select 'div.pagination'

    # There should be a link for each user
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), user.name
    end


  end


end
