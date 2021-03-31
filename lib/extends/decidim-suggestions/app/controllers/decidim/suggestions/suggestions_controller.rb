# frozen_string_literal: true

require "active_support/concern"

module SuggestionsControllerExtend
  extend ActiveSupport::Concern

  included do

    def default_filter_params
      {
        search_text: "",
        state: %w(accepted rejected answered open closed examinated debatted classified),
        type_id: default_filter_type_params,
        author: "any",
        scope_id: default_filter_scope_params,
        area_id: default_filter_area_params
      }
    end

  end
end

Decidim::Suggestions::SuggestionsController.send(:include, SuggestionsControllerExtend)
