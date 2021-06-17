# Clear menu items to reorder
Decidim::MenuRegistry.destroy(:menu)

Decidim.menu :menu do |menu|

  menu.item I18n.t("menu.home", scope: "decidim"),
            decidim.root_path,
            position: 1,
            active: :exclusive

  menu.item I18n.t("menu.processes", scope: "decidim"),
            decidim_participatory_processes.participatory_processes_path,
            position: 2,
            if: Decidim::ParticipatoryProcess.where(organization: current_organization).published.any?,
            active: :exclusive

  Decidim::NavbarLinks::NavbarLink.organization(current_organization).each do |navbar_link|
    menu.item translated_attribute(navbar_link.title),
              navbar_link.link,
              position: 3,
              active: :inclusive
  end

  menu.item I18n.t("menu.assemblies", scope: "decidim"),
            decidim_assemblies.assemblies_path,
            position: 4,
            if: Decidim::Assembly.where(organization: current_organization).published.any?,
            active: :inclusive

  menu.item I18n.t("menu.help", scope: "decidim"),
            decidim.pages_path,
            position: 5,
            active: :inclusive

end