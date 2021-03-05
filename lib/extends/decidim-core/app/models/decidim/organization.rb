# frozen_string_literal: true

require "active_support/concern"

module OrganizationExtend
  extend ActiveSupport::Concern

  included do
    def translatable_locales
      available_locales & Decidim.config.translatable_locales
    end

    #
    # `action` is one of:
    # - create
    # - sign
    #
    def initiatives_settings_allow_to?(user, action)
      initiatives_settings_minimum_age_allow_to?(user, action) &&
        initiatives_settings_allowed_region_allow_to?(user, action)
    end

    def initiatives_settings_minimum_age_allow_to?(user, action)
      return true if !user || user.admin?
      minimum_age = initiatives_settings_minimum_age(action)
      return true if minimum_age.blank?

      authorization = Decidim::Initiatives::UserAuthorizations.for(user).first
      return false if !authorization || authorization.metadata[:official_birth_date].blank?

      return false if (((Time.zone.now - authorization.metadata[:official_birth_date].in_time_zone) / 1.year.seconds).floor < minimum_age)

      true
    end

    def initiatives_settings_allowed_region_allow_to?(user, action)
      return true if !user || user.admin?
      allowed_region = initiatives_settings_allowed_region(action)
      return true if allowed_region.blank?
      region_codes = (Decidim::Organization::INITIATIVES_SETTINGS_ALLOWED_REGIONS.dig(allowed_region, :municipalities) || []).map{|m| m[:idM]}.uniq
      return true if region_codes.blank?

      authorization = Decidim::Initiatives::UserAuthorizations.for(user).first
      return false if !authorization || authorization.metadata[:postal_code].blank?

      return false unless region_codes.member?(authorization.metadata[:postal_code])

      true
    end

    def initiatives_settings_minimum_age(action)
      return if self.initiatives_settings.blank?
      self.initiatives_settings["#{action}_initiative_minimum_age"]
    end

    def initiatives_settings_allowed_region(action)
      return if self.initiatives_settings.blank?
      self.initiatives_settings["#{action}_initiative_allowed_region"]
    end

  end
end

Decidim::Organization.send(:include, OrganizationExtend)
