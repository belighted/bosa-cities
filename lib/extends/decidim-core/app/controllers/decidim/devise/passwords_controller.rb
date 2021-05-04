# frozen_string_literal: true

require "active_support/concern"

module DevisePasswordsControllerExtend
  extend ActiveSupport::Concern

  included do

    before_action :check_sign_in_enabled, only: []

  end
end

Decidim::Devise::PasswordsController.send(:include, DevisePasswordsControllerExtend)
