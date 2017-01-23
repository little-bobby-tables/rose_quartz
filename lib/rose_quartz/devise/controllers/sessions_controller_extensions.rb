# frozen_string_literal: true

module Devise
  module SessionsControllerExtensions
    def create
      super do |_resource|
        if request.env['rose_quartz.backup_code_used']
          flash[:alert] = t('rose_quartz.backup_code_used')
        end
      end
    end
  end
end
