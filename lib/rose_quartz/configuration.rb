# frozen_string_literal: true
module RoseQuartz
  class << self
    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.initialize!
    yield self.configuration
    insert_authentication_strategy!
  end

  def self.insert_authentication_strategy!
    ::Devise.setup do |c|
      c.warden do |warden|
        warden.default_strategies(scope: :user).unshift :two_factor_authenticable
      end
    end
  end

  class Configuration
    attr_accessor :issuer, :time_drift, :secret_encryption_key

    def initialize
      @issuer = ''
      @time_drift = 10.seconds
      @secret_encryption_key = 'ENCRYPTIONSECRET'
    end
  end
end
