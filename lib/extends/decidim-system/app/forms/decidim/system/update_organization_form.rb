# frozen_string_literal: true

require "active_support/concern"

module UpdateOrganizationFormExtend
  extend ActiveSupport::Concern

  included do
    attribute :castings_enabled, Virtus::Attribute::Boolean
    attribute :basic_auth_username, String
    attribute :basic_auth_password, String

    def set_from
      return from_email if from_label.blank?

      "#{from_label} <#{from_email}>"
    end

  end
end

Decidim::System::UpdateOrganizationForm.send(:include, UpdateOrganizationFormExtend)
