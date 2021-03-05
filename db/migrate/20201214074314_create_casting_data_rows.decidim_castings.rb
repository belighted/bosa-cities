# frozen_string_literal: true
# This migration comes from decidim_castings (originally 20201213141152)

class CreateCastingDataRows < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_casting_data_rows do |t|
      t.references :decidim_casting, null: false, index: false
      t.jsonb :attrs, null: false, default: {}
      t.text :raw_data

      t.timestamps

      t.index [:decidim_casting_id, :id, :attrs], name: "index_decidim_casting_data_rows_on_attrs", using: :gin
    end
  end
end
