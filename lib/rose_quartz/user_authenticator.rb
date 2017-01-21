# frozen_string_literal: true
require 'rotp'

module RoseQuartz
  class UserAuthenticator < ::ActiveRecord::Base
    belongs_to :user

    before_create :set_secret

    def set_secret
      self.secret = ROTP::Base32.random_base32
    end

    def authenticator
      @authenticator ||= ROTP::TOTP.new(secret)
    end

    def authenticate(token)
      authenticated_at = authenticator.verify_with_drift_and_prior(
          token, RoseQuartz.configuration.time_drift, last_authenticated_at)
      return false unless authenticated_at
      update_columns last_authenticated_at: authenticated_at
      true
    end
  end
end
