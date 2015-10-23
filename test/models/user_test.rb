require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup 
    @user = User.new(name: "Mitt", email: "mitt@me.com",
                      password: "wahoo1", password_confirmation: "wahoo1")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@food.com A_98-ER@foo.bar.org
                          first.last@foo.jp alice+bob@hoo.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
    test "email validation should reject invalid addresses" do
      invalid_addresses = %w[user@example,com USER_at_food.com A_98-ER@foo.
                          first.last@foo_baz.jp alice+bob@wa+hoo.cn]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "password should be present (not blank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should be a minimum length of 6" do
    @user.password = @user.password_confirmation = "m" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow & unfollow a user" do
    mitt = users(:mitt)
    sam = users(:sam)
    assert_not mitt.following?(sam)
    mitt.follow(sam)
    assert mitt.following?(sam)
    assert sam.followers.include?(mitt)
    mitt.unfollow(sam)
    assert_not mitt.following?(sam)
  end
  
  test "feed should have the right posts" do
    mitt  = users(:mitt)
    sam   = users(:sam)
    penny = users(:penny)
    # Posts from a followed user
    penny.microposts.each do |post_following|
      assert mitt.feed.include?(post_following)
    end
    # Posts from self
    mitt.microposts.each do |post_self|
      assert mitt.feed.include?(post_self)
    end
    # Posts from unfollowed user
    sam.microposts.each do |post_unfollowed|
      assert_not mitt.feed.include?(post_unfollowed)
    end
  end
  
end
