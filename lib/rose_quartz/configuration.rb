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
      c.warden do |manager|
        manager.default_strategies(scope: :user).unshift :two_factor_authenticatable
      end
    end
  end

  class Configuration
    attr_accessor :issuer, :time_drift

    def initialize
      @issuer = ''
      @time_drift = 60.seconds
    end
  end
end
