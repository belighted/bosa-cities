# frozen_string_literal: true

require "active_support/concern"

module AssemblyExtend
  extend ActiveSupport::Concern

  included do

    has_and_belongs_to_many :areas, class_name: "Decidim::Area", join_table: "decidim_assemblies_areas",
                            foreign_key: "decidim_assembly_id", association_foreign_key: "decidim_area_id"

  end
end

Decidim::Assembly.send(:include, AssemblyExtend)
