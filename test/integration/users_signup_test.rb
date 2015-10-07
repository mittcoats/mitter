require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "", email: "user@invalid",
                                password: "wah",
                                password_confirmation: "hoo"}
      end
      assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: "Mitt", email: "mitt@valid.com",
                                password: "password1",
                                password_confirmation: "password1"}
    end
    #assert_template 'users/show'
    #assert is_logged_in?
  end

end
