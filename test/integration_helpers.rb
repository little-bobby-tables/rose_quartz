class ActiveSupport::TestCase
  include ::FactoryGirl::Syntax::Methods

  def token_for(user, with_secret: nil, at: Time.now)
    authenticator = if with_secret
      RoseQuartz::UserAuthenticator.new(user_id: user.id, secret: with_secret)
    else
      RoseQuartz::UserAuthenticator.find_by(user_id: user.id)
    end
    authenticator.totp.at(at)
  end

  def authenticator_exists?(user)
    RoseQuartz::UserAuthenticator.exists? user_id: user.id
  end
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  def sign_in(user, email: user.email, password: user.password, token: nil)
    visit new_user_session_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Tf authentication token', with: token if token
    click_button 'Log in'
  end

  def sign_out
    reset_session!
  end

  def edit_user
    visit edit_user_registration_path(@user)
    yield if block_given?
    fill_in 'Current password', with: @user.password
    click_button 'Update'
  end

  # See test/dummy/app/views/pages/main.html.erb
  def assert_authenticated_as(user)
    visit '/' unless current_path == '/'
    assert find('#status').text == "You're logged in!", 'Expected the user to be signed in.'
    assert find('#user_id').text.to_i == user.id
  end

  def refute_authenticated
    visit '/' unless current_path == '/'
    assert find('#status').text == "You're logged out!", 'Expected the user to be signed out.'
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
