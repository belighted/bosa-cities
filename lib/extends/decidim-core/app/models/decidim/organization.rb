# frozen_string_literal: true

require "active_support/concern"

module OrganizationExtend
  extend ActiveSupport::Concern

  included do
    def translatable_locales
      available_locales & Decidim.config.translatable_locales
    end

    def basic_auth_enabled?
      self.basic_auth_username.present? || self.basic_auth_password.present?
    end

  end
end

Decidim::Organization.send(:include, OrganizationExtend)
