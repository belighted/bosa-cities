# frozen_string_literal: true

require "active_support/concern"

module AdminOfficializationsControllerExtend
  extend ActiveSupport::Concern

  included do

    def show_email
      raise Decidim::ActionForbidden
    end

  end
end

Decidim::Admin::OfficializationsController.send(:include, AdminOfficializationsControllerExtend)
