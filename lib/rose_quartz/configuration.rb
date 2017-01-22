# frozen_string_literal: true
module RoseQuartz
  class << self
    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.initialize!
    yield self.configuration
    Hooks.initialize_hooks!
  end

  class Configuration
    attr_accessor :issuer, :time_drift, :user_identifier

    def initialize
      @issuer = 'RoseQuartz'
      @time_drift = 1.minute
      @user_identifier = :email
    end
  end
end
