# frozen_string_literal: true
module RoseQuartz
  module Hooks
    def self.initialize_hooks!
      ::Devise.setup do |c|
        c.warden do |manager|
          manager.default_strategies(scope: :user).unshift :two_factor_authenticatable
        end
      end

      ::Devise::SessionsController.prepend Devise::SessionsControllerExtensions
      ::Devise::RegistrationsController.prepend Devise::RegistrationsControllerExtensions
    end
  end
end
