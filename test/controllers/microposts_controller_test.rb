require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase



  def setup
    @micropost = microposts(:orange)
  end


  test 'should redirect create when not logged in' do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: 'something'}
    end

    assert_redirected_to login_url

  end


  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost
    end

    assert_redirected_to login_url

  end


  test 'should redirect destroy if trying to delete another user\'s micropost' do
    log_in_as(users(:msh))
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: microposts(:fiona_post1)
    end
  end


end
