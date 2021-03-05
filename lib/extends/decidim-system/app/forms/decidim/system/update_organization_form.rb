# frozen_string_literal: true

require "active_support/concern"

module UpdateOrganizationFormExtend
  extend ActiveSupport::Concern

  included do
    jsonb_attribute :initiatives_settings, [
      [:allow_users_to_see_initiative_no_signature_option, Boolean],
      [:create_initiative_minimum_age, Integer],
      [:create_initiative_allowed_region, String],
      [:sign_initiative_minimum_age, Integer],
      [:sign_initiative_allowed_region, String]
    ]

    def set_from
      return from_email if from_label.blank?

      "#{from_label} <#{from_email}>"
    end

  end
end

Decidim::System::UpdateOrganizationForm.send(:include, UpdateOrganizationFormExtend)
