# frozen_string_literal: true

require "active_support/concern"

module ParticipatoryProcessExtend
  extend ActiveSupport::Concern

  included do

    has_and_belongs_to_many :areas, class_name: "Decidim::Area", join_table: "decidim_participatory_processes_areas",
                            foreign_key: "decidim_participatory_process_id", association_foreign_key: "decidim_area_id"

  end
end

Decidim::ParticipatoryProcess.send(:include, ParticipatoryProcessExtend)
