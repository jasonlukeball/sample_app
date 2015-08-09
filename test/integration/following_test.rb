require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest


  def setup
    @user = users(:jason)
    log_in_as(@user)
  end


  test 'following page' do

    get following_user_path(@user)
    assert_template 'users/show_follow'
    # Should be followering users
    assert_not @user.following.empty?
    # Should see the following count
    assert_match @user.following.count.to_s, response.body
    # Should be a link to each follower's page
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end


  end


  test 'followers page' do

    get followers_user_path(@user)
    assert_template 'users/show_follow'

    # Should have followers
    assert_not @user.followers.empty?
    # Should see the follower count
    assert_match @user.followers.count.to_s, response.body
    # Should be a link to each follower's page
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
    # Should see the followers count
    assert_match @user.followers.count.to_s, response.body

  end


end
