# frozen_string_literal: true

require "active_support/concern"

module AdminSuggestionFormExtend
  extend ActiveSupport::Concern

  included do

    attribute :area_ids, Array[Integer]

  end
end

Decidim::Suggestions::Admin::SuggestionForm.send(:include, AdminSuggestionFormExtend)
