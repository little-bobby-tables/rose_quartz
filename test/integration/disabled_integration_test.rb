require 'test_helper'

class DisabledIntegrationTest < ActionDispatch::IntegrationTest
  test 'allows to sign in and out without two-factor authentication enabled' do
    @user = create(:user)
    sign_in @user

    assert_authenticated_as @user

    sign_out

    refute_authenticated
  end

  test 'does not allow to sign in with an invalid email-password combination' do
    @user = create(:user)

    sign_in @user, password: 'querty'

    refute_authenticated
  end
end
