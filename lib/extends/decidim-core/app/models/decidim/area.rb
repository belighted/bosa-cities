# frozen_string_literal: true

require "active_support/concern"

module AreaExtend
  extend ActiveSupport::Concern

  included do
    attribute :color
    attribute :logo

    mount_uploader :logo, Decidim::AreaLogoUploader

    has_and_belongs_to_many :suggestions, class_name: "Decidim::Suggestion", join_table: "decidim_suggestions_areas",
                            foreign_key: "decidim_area_id", association_foreign_key: "decidim_suggestion_id"
    has_and_belongs_to_many :initiatives, class_name: "Decidim::Initiative", join_table: "decidim_initiatives_areas",
                            foreign_key: "decidim_area_id", association_foreign_key: "decidim_initiative_id"
    has_and_belongs_to_many :assemblies, class_name: "Decidim::Assembly", join_table: "decidim_assemblies_areas",
                            foreign_key: "decidim_area_id", association_foreign_key: "decidim_assembly_id"
    has_and_belongs_to_many :participatory_processes, class_name: "Decidim::ParticipatoryProcess", join_table: "decidim_participatory_processes_areas",
                            foreign_key: "decidim_area_id", association_foreign_key: "decidim_participatory_process_id"

  end
end

Decidim::Area.send(:include, AreaExtend)
