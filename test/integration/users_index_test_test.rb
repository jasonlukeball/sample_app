require 'test_helper'

class UsersIndexTestTest < ActionDispatch::IntegrationTest

  # Use a test user
  def setup
    @admin = users(:jason)
    @other_user = users(:msh)
  end

  test 'index as admin including pagination and delete links' do

    # Login as test user
    log_in_as(@admin)

    # Go to users index
    get users_path
    assert_template 'users/index'

    # Pagination should be working
    assert_select 'div.pagination'

    # There should be a link for each user
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      # There should be a delete link for each user
      assert_select 'a[href=?]', user_path(user), method: :delete
    end

    # Simulate deleting a user
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end

  end

  test 'index ad non-admin should not show delete links' do

    # Log in as non-admin user
    log_in_as(@other_user)

    # There should be no Delete links
    assert_select 'a', text: "Delete", count: 0

    # Simulate attempting to delete a user
    # There should be no difference in the total user count
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end

    # We should be redirected to the root_url
    assert_redirected_to root_url

  end

end
