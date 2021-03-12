# frozen_string_literal: true

require "active_support/concern"

module SuggestionSearchExtend
  extend ActiveSupport::Concern

  included do

    def search_area_id
      return query if area_ids.include?("all")

      query.
        joins("JOIN decidim_suggestions_areas ON decidim_suggestions.id = decidim_suggestions_areas.decidim_suggestion_id").
        where(decidim_suggestions_areas: {decidim_area_id: area_ids}).
        group("decidim_suggestions.id")
    end

  end
end

Decidim::Suggestions::SuggestionSearch.send(:include, SuggestionSearchExtend)
