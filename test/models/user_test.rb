require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "have unique email" do
    user = User.new(
      email: 'test@example.com',
      password: 'qwe123',
      password_confirmation: 'qwe123'
    )

    assert_not user.save
    assert user.errors[:email].present?
  end

  test "is database authenticable" do
    user = User.new(
      email: 'test2@example.com',
      password: 'qwe123',
      password_confirmation: 'qwe123'
    )

    assert user.save
    assert user.valid_password?('qwe123')
    assert user.authentication_token.present?
  end

  test "can be admin" do
    user = User.new(
      email: 'test2@example.com',
      password: 'qwe123',
      password_confirmation: 'qwe123',
      admin: true
    )

    assert user.admin?
  end
end
