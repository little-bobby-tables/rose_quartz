# Since the rest of the test suite relies on factories
# providing correct objects, it is important to make sure
# they behave as intended.
require 'test_helper'

class FactoriesTest < ActiveSupport::TestCase
  test ':user creates a user with two-factor authentication disabled' do
    @user = create(:user)
    refute authenticator_exists?(@user)
  end

  test ':user_with_tfa creates a user with two-factor authentication enabled' do
    @user = create(:user_with_tfa)
    assert authenticator_exists?(@user)
  end
end