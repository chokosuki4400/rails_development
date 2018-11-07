# frozen_string_literal: true

require 'test_helper'

class LoginsControllerTest < ActionDispatch::IntegrationTest
  test 'should get login' do
    get logins_login_url
    assert_response :success
  end

  test 'should get sign_up' do
    get logins_sign_up_url
    assert_response :success
  end
end
