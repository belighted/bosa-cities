# frozen_string_literal: true

require "active_support/concern"

module FilterFormBuilderExtend
  extend ActiveSupport::Concern

  included do

    def areas_select(method, collection, options = {}, html_options = {})
      fieldset_wrapper(options[:legend_title], "#{method}_areas_select_filter") do
        super(method, collection, options, html_options)
      end
    end

  end
end

Decidim::FilterFormBuilder.send(:include, FilterFormBuilderExtend)
