require 'test_helper'

class TwoFactorIntegrationTest < ActionDispatch::IntegrationTest
  test 'allows to sign in with a valid token' do
    @user = create(:user_with_tfa)
    sign_in @user, token: token_for(@user)

    assert_authenticated_as @user
  end

  test 'does not allow to sign in without a token' do
    @user = create(:user_with_tfa)
    sign_in @user

    refute_authenticated
  end

  test 'does not allow to sign in with an invalid token' do
    @user = create(:user_with_tfa)
    sign_in @user, token: 'wrong'

    refute_authenticated
  end

  test 'does not allow the token to be reused' do
    @user = create(:user_with_tfa)
    @token = token_for @user

    sign_in @user, token: @token
    sign_out
    sign_in @user, token: @token

    refute_authenticated
  end

  test 'allows to sign in with an expired token within a time drift window' do
    RoseQuartz.configuration.time_drift = 2.minutes
    @user = create(:user_with_tfa)

    @valid_tokens = [token_for(@user, at: Time.now - 1.minute),
                     token_for(@user, at: Time.now + 1.minute)]

    @valid_tokens.each do |token|
      sign_in @user, token: token
      assert_authenticated_as @user
      sign_out
    end
  end

  test 'does not allow to sign in with an expired token within a time drift window' do
    RoseQuartz.configuration.time_drift = 10.seconds
    @user = create(:user_with_tfa)

    @invalid_tokens = [token_for(@user, at: Time.now - 1.minute),
                       token_for(@user, at: Time.now + 1.minute)]

    @invalid_tokens.each do |token|
      sign_in @user, token: token
      refute_authenticated
    end
  end
end
