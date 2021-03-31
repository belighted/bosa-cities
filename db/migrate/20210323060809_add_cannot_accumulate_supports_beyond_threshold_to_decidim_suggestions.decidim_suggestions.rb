# frozen_string_literal: true
# This migration comes from decidim_suggestions (originally 20210322152153)

class AddCannotAccumulateSupportsBeyondThresholdToDecidimSuggestions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_suggestions, :cannot_accumulate_supports_beyond_threshold, :boolean, null: false, default: false
  end
end
