require 'test_helper'

class ControllerTest < ActionDispatch::IntegrationTest
  test 'enables two-factor authentication when a valid token is provided' do
    @user = create(:user)
    sign_in @user

    edit_user do
      secret = find('input#tfa_secret', visible: false).value
      token = token_for @user, with_secret: secret

      fill_in 'Token', with: token
    end

    assert authenticator_exists?(@user)
  end

  test 'allows two-factor authentication to be disabled' do
    @user = create(:user_with_tfa)
    sign_in @user, token: token_for(@user)

    edit_user do
      check 'Disable two-factor authentication'
    end

    refute authenticator_exists?(@user)
  end
end
