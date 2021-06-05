require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest

  #
  ### successfully create
  #
  test "returns 200 when creating new user" do
    create_new_user
    assert_response :success
  end

  test "returns proper response when creating new user" do
    create_new_user
    assert_equal({
      'data' => {
        'id' => Any,
        'type' => 'users',
        'attributes' => {
          'email' => 'test_2@example.com',
          'authentication-token' => Any
        }
      }
    }, response.parsed_body)
  end


  #
  ### user already exists
  #
  test "returns proper response when user already exists" do
    create_existing_user
    assert_equal({
      'errors' => [
        {
          'source' => { 'pointer' => '/data/attributes/email' },
          'detail' => 'has already been taken'
        }
      ]
    }, response.parsed_body)
  end

  test "returns 422 when user already exists" do
    create_existing_user
    assert_response :unprocessable_entity
  end


  #
  ### mismatched passwords
  #
  test "returns 422 when mismatched passwords" do
    create_user_with_mismatched_passwords
    assert_response :unprocessable_entity
  end

  test "returns proper response when mismatched passwords" do
    create_user_with_mismatched_passwords
    assert_equal({
      'errors' => [
        {
          'source' => { 'pointer' => '/data/attributes/password-confirmation' },
          'detail' => "doesn't match Password"
        }
      ]
    }, response.parsed_body)
  end


  #
  ### successfully signed in
  #
  test "returns 200 when successfully signed in" do
    user = users(:user_1)
    user.password = 'qwe123'

    sign_in(user)

    assert_response :success
  end

  test "returns proper response when successfully signed in" do
    user = users(:user_1)
    user.password = 'qwe123'

    sign_in(user)
    user.reload

    assert_equal({
      'data' => {
        'id' => Any,
        'type' => 'users',
        'attributes' => {
          'email' => user.email,
          'authentication-token' => user.authentication_token
        }
      }
    }, response.parsed_body)
  end

  #
  ### signed in with wrong password
  #
  test "return 422 when signed in with wrong password" do
    user = users(:user_1)
    user.password = 'qwe1234'

    sign_in(user)

    assert_response :unprocessable_entity
  end

  test "return proper message when signed in with wrong password" do
    user = users(:user_1)
    user.password = 'qwe1234'

    sign_in(user)

    assert_equal({
			"errors" => [
					{
							"source" => {
									"pointer" => "/data/attributes/password"
							},
							"detail" => "is invalid"
					}
			]
    }, response.parsed_body)
  end

  private

  def create_new_user
    user = User.new(
      email: 'test_2@example.com',
      password: 'qwe123',
      password_confirmation: 'qwe123'
    )
    create_user(user)
  end

  def create_existing_user
    user = User.new(
      email: 'test@example.com',
      password: 'qwe123',
      password_confirmation: 'qwe123'
    )
    create_user(user)
  end

  def create_user_with_mismatched_passwords
    user = User.new(
      email: 'test_2@example.com',
      password: 'qwe123',
      password_confirmation: 'qwe1234'
    )
    create_user(user)
  end

  def create_user(user)
    post api_v1_sign_up_path, params: {
      data: {
        type: :users,
        attributes: {
          email: user.email,
          password: user.password,
          password_confirmation: user.password_confirmation
        }
      }
    }
  end

  def sign_in(user)
    post api_v1_sign_in_path, params: {
      data: {
        type: :users,
        attributes: {
          email: user.email,
          password: user.password,
        }
      }
    }
  end
end
