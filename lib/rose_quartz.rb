# frozen_string_literal: true
require 'devise'

require 'rose_quartz/version'

require 'rose_quartz/hooks'
require 'rose_quartz/configuration'
require 'rose_quartz/user_authenticator'
require 'rose_quartz/devise/strategies/two_factor_authenticatable'
require 'rose_quartz/devise/controllers/sessions_controller_extensions'
require 'rose_quartz/devise/controllers/registrations_controller_extensions'
