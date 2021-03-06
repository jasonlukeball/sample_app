require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example Name", email: "example@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = "      "
    assert_not @user.valid?
    # returns false if empty string for user.name & test fails
  end

  test 'email should be present' do
    @user.email = "      "
    assert_not @user.valid?
    # returns false if empty string for user.email & test fails
  end

  test 'the name should not be too long' do
    # Set user's name to a string 51 characters long
    @user.name = "a" * 51
    assert_not @user.valid?
    # Returns true, user's name > 50 characters is NOT VALID
  end

  test 'the email should not be too long' do
    # Set user's email to a string 256 characters long
    @user.email = "a" * 256
    assert_not @user.valid?
    # Returns true, user's email > 255 characters is NOT VALID
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn ]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
      end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email address should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'password should be minimum 6 characters' do
    @user.password = "a" * 5
    @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test 'associated microposts should be destroyed when deleting user' do
    # Save @user to the database
    @user.save
    # Create an associated micropost for @user
    @user.microposts.create!(content: 'Yay, I\'m a micropost')
    # Micropost count should be one less after we delete the user
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end


  end

  test 'should follow and unfollow a user' do


    # Setup some users
    jason = users(:jason)
    msh   = users(:msh)

    # Should not be following
    assert_not jason.following?(msh)

    # Follow a user
    jason.follow(msh)
    # Should now be following
    assert jason.following?(msh)

    # Msh's followers should include jason
    assert msh.followers.include?(jason)

    # Unfollow a user
    jason.unfollow(msh)
    # Should not be following
    assert_not jason.following?(msh)



  end

  test 'feed should have the right posts' do
    jason = users(:jason)
    fiona = users(:fiona)
    roz   = users(:roz)
    msh   = users(:msh)

    # Posts from followed user
    # Fiona's posts should appear in Jason's feed
    fiona.microposts.each do |post_following|
      assert jason.feed.include?(post_following)
    end

    # Posts from self
    jason.microposts.each do |post_self|
      assert jason.feed.include?(post_self)
    end

    # Posts from unfollowed user
    msh.microposts.each do |post_unfollowed|
      assert_not jason.feed.include?(post_unfollowed)
    end








  end


end
