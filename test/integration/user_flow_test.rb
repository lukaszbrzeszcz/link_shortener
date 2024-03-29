# frozen_string_literal: true

require 'test_helper'
require 'integration_test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  include IntegrationTestHelper

  #
  ### successfully create
  #
  test 'returns 200 when creating new user' do
    create_new_user
    assert_response :success
  end

  test 'returns proper response when creating new user' do
    create_new_user
    assert_equal({
                   'data' => {
                     'id' => Any,
                     'type' => 'users',
                     'attributes' => {
                       'email' => 'xxx@example.com',
                       'authentication-token' => Any
                     }
                   }
                 }, response.parsed_body)
  end

  #
  ### user already exists
  #
  test 'returns proper response when user already exists' do
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

  test 'returns 422 when user already exists' do
    create_existing_user
    assert_response :unprocessable_entity
  end

  #
  ### mismatched passwords
  #
  test 'returns 422 when mismatched passwords' do
    create_user_with_mismatched_passwords
    assert_response :unprocessable_entity
  end

  test 'returns proper response when mismatched passwords' do
    create_user_with_mismatched_passwords
    assert_equal({
                   'errors' => [
                     {
                       'source' => { 'pointer' => '/data/attributes/password-confirmation' },
                       'detail' => 'doesn\'t match Password'
                     }
                   ]
                 }, response.parsed_body)
  end

  #
  ### successfully signed in
  #
  test 'returns 200 when successfully signed in' do
    user = users(:jim)

    sign_in(user, 'qwe123')

    assert_response :success
  end

  test 'returns proper response when successfully signed in' do
    user = users(:jim)

    sign_in(user, 'qwe123')
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
  test 'return 422 when signed in with wrong password' do
    user = users(:jim)

    sign_in(user, 'qwe1234')

    assert_response :unprocessable_entity
  end

  test 'return proper message when signed in with wrong password' do
    user = users(:jim)

    sign_in(user, 'qwe1234')

    assert_equal({
                   'errors' => [
                     {
                       'source' => {
                         'pointer' => '/data/attributes/password'
                       },
                       'detail' => 'is invalid'
                     }
                   ]
                 }, response.parsed_body)
  end

  private

  def create_new_user
    user = User.new(
      email: 'xxx@example.com',
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
end
