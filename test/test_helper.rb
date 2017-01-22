ENV['RAILS_ENV'] = 'test'

require 'simplecov'
SimpleCov.start do
  add_filter 'test'
end

require File.expand_path('../../test/dummy/config/environment.rb', __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../../test/dummy/db/migrate', __FILE__)]

require 'devise'
require 'rails/test_help'
require 'minitest/reporters'

require 'factory_girl'
require 'factories'

require 'devise_integration_helpers'
require 'warden_integration_helpers'

require 'rose_quartz'

Rails.backtrace_cleaner.remove_silencers!
Minitest.backtrace_filter = Minitest::BacktraceFilter.new
Minitest::Reporters.use!

class ActiveSupport::TestCase
  include ::FactoryGirl::Syntax::Methods
end

def token_for(user, at: Time.now)
  authenticator = RoseQuartz::UserAuthenticator.find_by(user_id: user.id)
  authenticator.totp.at(at)
end
