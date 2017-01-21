class ActionDispatch::IntegrationTest
  def warden
    request.env['warden']
  end

  def current_user
    warden.user
  end

  def user_authenticated?
    warden.authenticate?(:user)
  end

  def assert_authenticated_as(user)
    assert user_authenticated?
    assert_equal user, current_user
  end

  def refute_authenticated
    refute user_authenticated?
    assert_nil current_user
  end
end
