require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jason)
  end


  test 'profile displays' do

    # Go to user profile
    get user_path(@user.id)
    # Should render the correct view
    assert_template 'users/show'
    # Title should be correct
    assert_select 'title', "#{@user.name} | Ruby on Rails Tutorial Sample App"
    # Should see a H1 with the user's name
    assert_select 'h1', text: @user.name
    # Should be an image inside the H1 with the gravatar class
    assert_select 'h1>img.gravatar'

    # Micropost count should exist on the page
    assert_match @user.microposts.count.to_s, response.body
    # Pagination should be working
    assert_select 'div.pagination'

    @user.microposts.paginate(page:1).each do |micropost|
      assert_match micropost.content, response.body
    end








  end



end
