# frozen_string_literal: true

class AddCannotAccumulateSupportsBeyondThresholdToDecidimInitiatives < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_initiatives, :cannot_accumulate_supports_beyond_threshold, :boolean, null: false, default: false
  end
end
