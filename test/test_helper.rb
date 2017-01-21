ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../test/dummy/config/environment.rb', __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../../test/dummy/db/migrate', __FILE__)]

require 'devise'
require 'rails/test_help'

require 'factory_girl'
require 'factories'

require 'devise_integration_helpers'
require 'warden_integration_helpers'

require 'rose_quartz'

Rails.backtrace_cleaner.remove_silencers!
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

class ActiveSupport::TestCase
  include ::FactoryGirl::Syntax::Methods
end

def token_for(user, at: Time.now)
  auth_model = RoseQuartz::UserAuthenticator.find_by(user_id: user.id)
  auth_model.authenticator.at(at)
end
