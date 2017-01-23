require 'test_helper'

class BackupCodeTest < ActionDispatch::IntegrationTest
  test 'allows to sign in with the backup code instead of a totp' do
    @user = create(:user_with_tfa)
    sign_in @user, token: backup_code_for(@user)

    assert_authenticated_as @user
  end

  test 'does not allow to sign in with an invalid backup code' do
    @user = create(:user_with_tfa)
    sign_in @user, token: backup_code_for(@user).succ

    refute_authenticated
  end

  test 'allows user to reset backup code' do
    @user = create(:user_with_tfa)
    @backup_code_was = backup_code_for(@user)
    sign_in @user, token: backup_code_for(@user)

    edit_user do
      check 'Reset backup code'
    end

    refute_equal @backup_code_was, backup_code_for(@user)
  end
end
