# Clear menu items to reorder
Decidim::MenuRegistry.destroy(:user_menu)

Decidim.menu :user_menu do |menu|
  menu.item t("account", scope: "layouts.decidim.user_profile"),
            decidim.account_path,
            position: 1.0,
            active: :exact

  menu.item t("notifications_settings", scope: "layouts.decidim.user_profile"),
            decidim.notifications_settings_path,
            position: 1.1

  # if available_verification_workflows.any?
  #   menu.item t("authorizations", scope: "layouts.decidim.user_profile"),
  #             decidim_verifications.authorizations_path,
  #             position: 1.2
  # end

  if current_organization.user_groups_enabled? && user_groups.any?
    menu.item t("user_groups", scope: "layouts.decidim.user_profile"),
              decidim.own_user_groups_path,
              position: 1.3
  end

  menu.item t("my_interests", scope: "layouts.decidim.user_profile"),
            decidim.user_interests_path,
            position: 1.4

  menu.item t("my_data", scope: "layouts.decidim.user_profile"),
            decidim.data_portability_path,
            position: 1.5

  menu.item t("delete_my_account", scope: "layouts.decidim.user_profile"),
            decidim.delete_account_path,
            position: 999,
            active: :exact
end
