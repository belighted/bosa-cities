# frozen_string_literal: true

require "active_support/concern"

module VerificationsOmniauthAuthorizationsControllerExtend
  extend ActiveSupport::Concern

  included do

    def redirect_url
      @redirect_url ||= request.referer || decidim_verifications.authorizations_path
    end

  end
end

Decidim::Verifications::Omniauth::AuthorizationsController.send(:include, VerificationsOmniauthAuthorizationsControllerExtend)
