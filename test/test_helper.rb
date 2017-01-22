ENV['RAILS_ENV'] = 'test'

require 'simplecov'
SimpleCov.start do
  add_filter 'test'
end

require File.expand_path('../../test/dummy/config/environment.rb', __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path('../../test/dummy/db/migrate', __FILE__)]

require 'devise'
require 'rails/test_help'
require 'capybara/rails'
require 'minitest/reporters'

require 'factory_girl'
require 'factories'

require 'integration_helpers'

require 'rose_quartz'

Rails.backtrace_cleaner.remove_silencers!
Minitest.backtrace_filter = Minitest::BacktraceFilter.new
Minitest::Reporters.use!
