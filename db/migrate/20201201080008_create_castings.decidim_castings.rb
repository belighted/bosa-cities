# frozen_string_literal: true
# This migration comes from decidim_castings (originally 20201201061821)

class CreateCastings < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_castings do |t|
      t.references :decidim_organization, null: false, index: false
      t.bigint :decidim_author_id, null: false
      t.string :decidim_author_type, null: false
      t.string :title, null: false
      t.text :description
      t.string :status, null: false, default: 'created'
      t.jsonb :status_errors

      # step 1 - data source
      t.string :data_source, null: false, default: 'file'
      t.datetime :data_source_imported_at
      t.string :file, null: false
      t.string :file_content_type, null: false
      t.string :file_size, null: false
      t.boolean :file_first_row_is_a_header, null: false, default: true
      t.string :file_columns_separator, null: false, default: ','
      t.jsonb :data_source_statistics

      # step 2 - data attributes mapping
      t.jsonb :attrs_mapping

      # step 3 - selection criteria
      t.integer :amount_of_candidates, null: false, default: 0
      t.jsonb :selection_criteria

      t.timestamps

      t.index [:decidim_organization_id, :status]
      t.index [:decidim_author_id, :decidim_author_type], name: "index_decidim_castings_on_decidim_author"
    end
  end
end
