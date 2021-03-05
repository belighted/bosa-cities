# frozen_string_literal: true

require "active_support/concern"

module UpdateOrganizationFormExtend
  extend ActiveSupport::Concern

  included do

    def set_from
      return from_email if from_label.blank?

      "#{from_label} <#{from_email}>"
    end

  end
end

Decidim::System::UpdateOrganizationForm.send(:include, UpdateOrganizationFormExtend)
