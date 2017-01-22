module RoseQuartz
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    def copy_initializer
      copy_file 'initializer.rb', 'config/initializers/rose_quartz.rb'
    end

    def copy_locale
      copy_file 'locale.en.yml', 'config/locales/rose_quartz.en.yml'
    end

    def copy_migration
      migration_template 'migration.rb', 'db/migrate/add_two_factor_auth_with_rose_quartz.rb'
    end

    def self.next_migration_number(path)
      next_migration_number = current_migration_number(path) + 1
      ActiveRecord::Migration.next_migration_number(next_migration_number)
    end
  end
end
