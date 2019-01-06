require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest

  test "new user succeeded to sign up" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {username: 'User1993', email: 'user@email.com', password: 'password'}}
      follow_redirect!
    end
    assert_template 'users/show'
    assert_match 'User1993', response.body
  end

  test "new user failed to sign up" do
  get signup_path
  assert_template 'users/new'
  assert_no_difference 'User.count' do
    post users_path, params: { user: {username: '', email: 'useremail.com', password: ''}}
  end
  assert_template 'users/new'
  end

end
