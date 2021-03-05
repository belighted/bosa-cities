# frozen_string_literal: true

require "active_support/concern"

module SuggestionsApplicationHelperExtend
  extend ActiveSupport::Concern

  included do
    include Decidim::CheckBoxesTreeHelper

    def filter_scopes_values
      main_scopes = current_organization.scopes.top_level

      scopes_values = main_scopes.includes(:scope_type, :children).flat_map do |scope|
        Decidim::CheckBoxesTreeHelper::TreeNode.new(
          Decidim::CheckBoxesTreeHelper::TreePoint.new(scope.id.to_s, translated_attribute(scope.name, current_organization)),
          scope_children_to_tree(scope)
        )
      end

      # scopes_values.prepend(Decidim::CheckBoxesTreeHelper::TreePoint.new("global", t("decidim.scopes.global")))

      Decidim::CheckBoxesTreeHelper::TreeNode.new(
        Decidim::CheckBoxesTreeHelper::TreePoint.new("", t("decidim.suggestions.application_helper.filter_scope_values.all")),
        scopes_values
      )
    end

    def filter_areas(areas)
      areas.map do |area|
        Decidim::CheckBoxesTreeHelper::TreeNode.new(
          Decidim::CheckBoxesTreeHelper::TreePoint.new(area.id.to_s, area.name[I18n.locale.to_s])
        )
      end.sort_by{|a| a.leaf.label}
    end

  end
end

Decidim::Suggestions::ApplicationHelper.send(:include, SuggestionsApplicationHelperExtend)
