require 'test_helper'

class MicropostTest < ActiveSupport::TestCase


  def setup
    @user = users(:jason)
    @micropost = Micropost.new(user_id: @user.id, content: 'Hello Rails!')
  end


  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'user_id should be present' do
    # Set user_id to nil
    @micropost.user_id = nil
    # Should not be valid if no user_id
    assert_not @micropost.valid?
  end


  test 'content should be present' do
    # Set user_id to nil
    @micropost.content = nil
    # Should not be valid if no content
    assert_not @micropost.valid?
  end


  test 'content should be <= 140 characters' do
    # Set the micropost content to 141 characters
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end


end
