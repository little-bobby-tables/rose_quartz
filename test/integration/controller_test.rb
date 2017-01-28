require 'test_helper'

class ControllerTest < ActionDispatch::IntegrationTest
  test 'enables two-factor authentication when a valid token is provided' do
    @user = create(:user)
    sign_in @user

    edit_user do
      secret = find('input#two_factor_authentication_secret', visible: false).value
      token = token_for @user, with_secret: secret

      fill_in 'Token', with: token
    end

    assert authenticator_exists?(@user)
  end

  test 'disables two-factor authentication if requested' do
    @user = create(:user_with_tfa)
    sign_in @user, token: token_for(@user)

    edit_user

    assert authenticator_exists?(@user)

    edit_user do
      check 'Disable two-factor authentication'
    end

    refute authenticator_exists?(@user)
  end

  test 'does not enable two-factor authentication without a valid token provided' do
    @user = create(:user)
    sign_in @user

    edit_user

    assert_text I18n.t 'rose_quartz.invalid_token_when_enabling_tfa'
    refute authenticator_exists?(@user)

    edit_user do
      fill_in 'Token', with: 'nope'
    end

    assert_text I18n.t 'rose_quartz.invalid_token_when_enabling_tfa'
    refute authenticator_exists?(@user)
  end

  test 'does not enable two-factor authentication without a password provided' do
    @user = create(:user)
    sign_in @user

    edit_user(fill_in_password: false) do
      secret = find('input#two_factor_authentication_secret', visible: false).value
      token = token_for @user, with_secret: secret

      fill_in 'Token', with: token
    end

    refute authenticator_exists?(@user)
  end
end
