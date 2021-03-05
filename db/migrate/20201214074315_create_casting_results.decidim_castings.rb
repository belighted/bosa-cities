# frozen_string_literal: true
# This migration comes from decidim_castings (originally 20201213162245)

class CreateCastingResults < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_casting_results do |t|
      t.references :decidim_casting, null: false, index: true

      t.integer :run_number, null: false, default: 1
      t.integer :number_of_trials
      t.jsonb :statistics

      t.string :candidates_file
      t.string :substitutes_file

      t.timestamps
    end
  end
end
