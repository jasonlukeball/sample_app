require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example Name", email: "example@example.com")
  end


  test "should be valid" do
    assert @user.valid?
  end


  test "name should be present" do
    @user.name = "      "
    assert_not @user.valid?
    # returns false if empty string for user.name & test fails
  end


  test "email should be present" do
    @user.email = "      "
    assert_not @user.valid?
    # returns false if empty string for user.email & test fails
  end


  test "the name should not be too long" do
    # Set user's name to a string 51 characters long
    @user.name = "a" * 51
    assert_not @user.valid?
    # Returns true, user's name > 50 characters is NOT VALID
  end


  test "the email should not be too long" do
    # Set user's email to a string 256 characters long
    @user.email = "a" * 256
    assert_not @user.valid?
    # Returns true, user's email > 255 characters is NOT VALID
  end


end
