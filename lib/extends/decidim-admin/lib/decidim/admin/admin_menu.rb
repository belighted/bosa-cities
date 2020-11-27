# # Clear menu items to reorder
# Decidim::MenuRegistry.destroy(:admin_menu)
#
# Decidim.menu :admin_menu do |menu|
#   menu.item I18n.t("menu.dashboard", scope: "decidim.admin"),
#             decidim_admin.root_path,
#             icon_name: "dashboard",
#             position: 1,
#             active: ["decidim/admin/dashboard" => :show]
#
#   menu.item I18n.t("menu.suggestions", scope: "decidim.admin"),
#             decidim_admin_suggestions.suggestions_path,
#             icon_name: "task",
#             position: 2,
#             active: :inclusive,
#             if: allowed_to?(:enter, :space_area, space_name: :suggestions)
#
#   menu.item I18n.t("menu.assemblies", scope: "decidim.admin"),
#             decidim_admin_assemblies.assemblies_path,
#             icon_name: "dial",
#             position: 3,
#             active: :inclusive,
#             if: allowed_to?(:enter, :space_area, space_name: :assemblies)
#
#   menu.item I18n.t("menu.initiatives", scope: "decidim.admin"),
#             decidim_admin_initiatives.initiatives_path,
#             icon_name: "chat",
#             position: 4,
#             active: :inclusive,
#             if: allowed_to?(:enter, :space_area, space_name: :initiatives)
#
#   menu.item I18n.t("menu.participatory_processes", scope: "decidim.admin"),
#             decidim_admin_participatory_processes.participatory_processes_path,
#             icon_name: "target",
#             position: 5,
#             active: is_active_link?(decidim_admin_participatory_processes.participatory_processes_path, :inclusive) ||
#               is_active_link?(decidim_admin_participatory_processes.participatory_process_groups_path, :inclusive),
#             if: allowed_to?(:enter, :space_area, space_name: :processes) || allowed_to?(:enter, :space_area, space_name: :process_groups)
#
#   menu.item I18n.t("menu.static_pages", scope: "decidim.admin"),
#             decidim_admin.static_pages_path,
#             icon_name: "book",
#             position: 6,
#             active: [%w(
#                       decidim/admin/static_pages
#                       decidim/admin/static_page_topics
#                     ), []],
#             if: allowed_to?(:read, :static_page)
#
#   menu.item I18n.t("menu.users", scope: "decidim.admin"),
#             allowed_to?(:read, :admin_user) ? decidim_admin.users_path : decidim_admin.impersonatable_users_path,
#             icon_name: "person",
#             position: 7,
#             active: [%w(user_groups users managed_users impersonatable_users authorization_workflows).map {|segment| "/decidim/admin/#{segment}"}, []],
#             if: allowed_to?(:read, :admin_user) || allowed_to?(:read, :managed_user)
#
#   menu.item I18n.t("menu.newsletters", scope: "decidim.admin"),
#             decidim_admin.newsletters_path,
#             icon_name: "envelope-closed",
#             position: 8,
#             active: :inclusive,
#             if: allowed_to?(:index, :newsletter)
#
#   menu.item I18n.t("menu.settings", scope: "decidim.admin"),
#             decidim_admin.edit_organization_path,
#             icon_name: "wrench",
#             position: 9,
#             active: [
#               %w(
#                         decidim/admin/organization
#                         decidim/admin/organization_appearance
#                         decidim/admin/organization_homepage
#                         decidim/admin/organization_homepage_content_blocks
#                         decidim/admin/scopes
#                         decidim/admin/scope_types
#                         decidim/admin/areas decidim/admin/area_types
#                         decidim/admin/help_sections
#                       ),
#               []
#             ],
#             if: allowed_to?(:update, :organization, organization: current_organization)
#
#   menu.item I18n.t("menu.term_customizer", scope: "decidim.term_customizer"),
#             decidim_admin_term_customizer.translation_sets_path,
#             icon_name: "text",
#             position: 10,
#             active: :inclusive,
#             if: allowed_to?(:update, :organization, organization: current_organization)
#
#   menu.item I18n.t("menu.admin_log", scope: "decidim.admin"),
#             decidim_admin.logs_path,
#             icon_name: "align-left",
#             position: 11,
#             active: [%w(decidim/admin/logs), []],
#             if: allowed_to?(:read, :admin_log)
#
#   menu.item I18n.t("menu.oauth_applications", scope: "decidim.admin"),
#             decidim_admin.oauth_applications_path,
#             icon_name: "account-login",
#             position: 12,
#             active: [%w(decidim/admin/oauth_applications), []],
#             if: allowed_to?(:read, :oauth_application)
# end
