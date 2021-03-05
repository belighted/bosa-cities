# frozen_string_literal: true

require "active_support/concern"

module InitiativesTypeScopeExtend
  extend ActiveSupport::Concern

  included do

    def global_scope?
      decidim_scopes_id.nil?
    end

    def scope_name
      return {I18n.locale.to_s => I18n.t("decidim.scopes.global")} if global_scope?

      scope&.name.presence || {I18n.locale.to_s => I18n.t("decidim.initiatives.unavailable_scope")}
    end

  end
end

Decidim::InitiativesTypeScope.send(:include, InitiativesTypeScopeExtend)
