# frozen_string_literal: true

require "active_support/concern"

module AdminUpdateOrganizationExtend
  extend ActiveSupport::Concern

  included do
    private

    def attributes
      {
        name: form.name,
        default_locale: form.default_locale,
        reference_prefix: form.reference_prefix,
        time_zone: form.time_zone,
        twitter_handler: form.twitter_handler,
        facebook_handler: form.facebook_handler,
        instagram_handler: form.instagram_handler,
        youtube_handler: form.youtube_handler,
        github_handler: form.github_handler,
        badges_enabled: form.badges_enabled,
        user_groups_enabled: form.user_groups_enabled,
        admin_terms_of_use_body: form.admin_terms_of_use_body,
        rich_text_editor_in_public_views: form.rich_text_editor_in_public_views
      }.merge(welcome_notification_attributes)
        .merge(translation_settings)
    end

    def translation_settings
      {
        deepl_api_key: form.deepl_api_key
      }
    end
  end
end

Decidim::Admin::UpdateOrganization.send(:include, AdminUpdateOrganizationExtend)
