# frozen_string_literal: true
# This migration comes from decidim_suggestions (originally 20210326152153)

class MoveCannotAccumulateSupportsBeyondThresholdToDecidimSuggestionsTypes < ActiveRecord::Migration[5.2]
  def up
    remove_column :decidim_suggestions, :cannot_accumulate_supports_beyond_threshold
    add_column :decidim_suggestions_types, :cannot_accumulate_supports_beyond_threshold, :boolean, null: false, default: false
  end

  def down
    remove_column :decidim_suggestions_types, :cannot_accumulate_supports_beyond_threshold
    add_column :decidim_suggestions, :cannot_accumulate_supports_beyond_threshold, :boolean, null: false, default: false
  end
end
