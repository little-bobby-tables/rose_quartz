class ActionDispatch::IntegrationTest
  def sign_in(user, email: user.email, password: user.password, token: nil)
    post new_user_session_path, params: {
        user: { email: email, password: password, password_confirmation: password },
        tf_authentication_token: token
    }
  end

  def sign_out
    delete destroy_user_session_path
  end
end
