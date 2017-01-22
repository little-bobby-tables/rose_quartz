module RoseQuartz
  class InstallGenerator < Rails::Generators::Base
    desc 'This generator creates an initializer file at config/initializers and a localization file at config/locales'

    source_root File.expand_path('../templates', __FILE__)

    def copy_initializer
      copy_file 'initializer.rb', 'config/initializers/rose_quartz.rb'
    end

    def copy_locale
      copy_file 'locale.en.yml', 'config/locales/rose_quartz.en.yml'
    end
  end
end
