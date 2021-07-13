# frozen_string_literal: true

require "active_support/concern"

module SearchExtend
  extend ActiveSupport::Concern

  included do

    private

    def filtered_query_for(class_name)
      # Don't display the users in search
      return [] if class_name == 'Decidim::User'

      query = Decidim::SearchableResource.where(organization: organization, locale: I18n.locale)
      query = query.where(resource_type: class_name)

      clean_filters.each_pair do |attribute_name, value|
        query = query.where(attribute_name => value)
      end

      query = query.order("datetime DESC")
      query = query.global_search(I18n.transliterate(term)) if term.present?
      query
    end

  end
end

Decidim::Search.send(:include, SearchExtend)
