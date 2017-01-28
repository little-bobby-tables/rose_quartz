require 'test_helper'

class BackupCodeTest < ActionDispatch::IntegrationTest
  test 'allows to sign in with the backup code instead of a totp' do
    @user = create(:user_with_tfa)
    sign_in @user, token: backup_code_for(@user)

    assert_authenticated_as @user
  end

  test 'resets a backup code once it has been used and flashes a corresponding message' do
    @user = create(:user_with_tfa)
    @backup_code_was = backup_code_for(@user)
    sign_in @user, token: backup_code_for(@user)

    refute_equal @backup_code_was, backup_code_for(@user)
    assert_text I18n.t 'rose_quartz.backup_code_used'
  end

  test 'does not allow to sign in with an invalid backup code' do
    @user = create(:user_with_tfa)
    sign_in @user, token: backup_code_for(@user).succ

    refute_authenticated
  end

  test 'allows the user to reset backup code' do
    @user = create(:user_with_tfa)
    @backup_code_was = backup_code_for(@user)
    sign_in @user, token: backup_code_for(@user)

    edit_user do
      check 'Reset backup code'
    end

    refute_equal @backup_code_was, backup_code_for(@user)
  end

  test 'reminds the user to copy the backup code when they enable two-factor authentication' do
    @user = create(:user)
    sign_in @user

    edit_user do
      secret = find('input#two_factor_authentication_secret', visible: false).value
      token = token_for @user, with_secret: secret

      fill_in 'Token', with: token
    end

    assert_text I18n.t 'rose_quartz.tfa_enabled'
  end
end
