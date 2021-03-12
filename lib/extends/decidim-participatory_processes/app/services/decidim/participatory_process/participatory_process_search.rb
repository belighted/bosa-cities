# frozen_string_literal: true

require "active_support/concern"

module ParticipatoryProcessSearchExtend
  extend ActiveSupport::Concern

  included do

    def search_area_id
      return query if area_id.blank?

      query.
        joins("JOIN decidim_participatory_processes_areas ON decidim_participatory_processes.id = decidim_participatory_processes_areas.decidim_participatory_process_id").
        where(decidim_participatory_processes_areas: {decidim_area_id: area_id})
    end

  end
end

Decidim::ParticipatoryProcesses::ParticipatoryProcessSearch.send(:include, ParticipatoryProcessSearchExtend)
