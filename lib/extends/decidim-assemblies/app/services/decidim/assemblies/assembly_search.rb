# frozen_string_literal: true

require "active_support/concern"

module AssemblySearchExtend
  extend ActiveSupport::Concern

  included do

    def search_area_id
      return query if area_id.blank?

      query.
        joins("JOIN decidim_assemblies_areas ON decidim_assemblies.id = decidim_assemblies_areas.decidim_assembly_id").
        where(decidim_assemblies_areas: {decidim_area_id: area_id})
    end

  end
end

Decidim::Assemblies::AssemblySearch.send(:include, AssemblySearchExtend)
