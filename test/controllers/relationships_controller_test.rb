require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase


  test 'create should redirect when not logged in' do

    # Should be no difference when not logged in
    assert_no_difference 'Relationship.count' do
       post :create
     end
    # Should be redirected
    assert_redirected_to login_url

  end


  test 'destroy should redirect when not logged in' do

    # Should be no difference when not logged in
    assert_no_difference 'Relationship.count' do
      delete :destroy, id: relationships(:one)
    end
    # Should be redirected
    assert_redirected_to login_url

  end





end
