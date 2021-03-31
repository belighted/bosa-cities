# frozen_string_literal: true

class MoveCannotAccumulateSupportsBeyondThresholdToDecidimInitiativesTypes < ActiveRecord::Migration[5.2]
  def up
    remove_column :decidim_initiatives, :cannot_accumulate_supports_beyond_threshold
    add_column :decidim_initiatives_types, :cannot_accumulate_supports_beyond_threshold, :boolean, null: false, default: false
  end

  def down
    remove_column :decidim_initiatives_types, :cannot_accumulate_supports_beyond_threshold
    add_column :decidim_initiatives, :cannot_accumulate_supports_beyond_threshold, :boolean, null: false, default: false
  end
end
