# # Clear menu items to reorder
# Decidim::MenuRegistry.destroy(:menu)
#
# Decidim.menu :menu do |menu|
#
#   menu.item I18n.t("menu.home", scope: "decidim"),
#             decidim.root_path,
#             position: 1,
#             active: :exclusive
#
#   menu.item I18n.t("menu.suggestions", scope: "decidim"),
#             decidim_suggestions.suggestions_path,
#             position: 2,
#             if: Decidim::SuggestionsType.where(organization: current_organization).any?,
#             active: :inclusive
#
#   menu.item I18n.t("menu.assemblies", scope: "decidim"),
#             decidim_assemblies.assemblies_path,
#             position: 3,
#             if: Decidim::Assembly.where(organization: current_organization).published.any?,
#             active: :inclusive
#
#   menu.item I18n.t("menu.initiatives", scope: "decidim"),
#             decidim_initiatives.initiatives_path,
#             position: 4,
#             if: Decidim::InitiativesType.where(organization: current_organization).any?,
#             active: :inclusive
#
#   menu.item I18n.t("menu.help", scope: "decidim"),
#             decidim.pages_path,
#             position: 5,
#             active: :inclusive
#
# end
