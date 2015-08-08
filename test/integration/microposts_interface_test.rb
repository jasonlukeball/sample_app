require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest


  def setup
    @user = users(:jason)
  end


  test 'micropost interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'

    # Make invalid micropost submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, micropost: { content: ''}
    end
    # Should render errors
    assert_select 'div#error_explanations'

    # Make valid submission
    content = 'This is the best post ever'
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: { content: content}
    end
    assert_redirected_to root_url
    follow_redirect!
    # Should see the new micropost on the page
    assert_match content, response.body

    # Delete a micropost
    # Should be delete links on the page
    assert_select 'a', text: 'Delete'
    # Should be a difference in the count after deleting one micropost
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # Visit a different user
    get user_path(users(:msh))
    # Should be NO delete links
    assert_select 'a', text: 'Delete', count: 0

  end


end
