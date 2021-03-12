# frozen_string_literal: true

class CreateHasManyAreasTables < ActiveRecord::Migration[5.2]
  def up
    create_table :decidim_suggestions_areas do |t|
      t.references :decidim_suggestion, null: false, index: false
      t.references :decidim_area, null: false, index: true
      t.timestamps
    end
    add_index :decidim_suggestions_areas, [:decidim_suggestion_id, :decidim_area_id], unique: true, name: 'index_unique_suggestion_and_area'

    create_table :decidim_initiatives_areas do |t|
      t.references :decidim_initiative, null: false, index: false
      t.references :decidim_area, null: false, index: true
      t.timestamps
    end
    add_index :decidim_initiatives_areas, [:decidim_initiative_id, :decidim_area_id], unique: true, name: 'index_unique_initiative_and_area'

    create_table :decidim_assemblies_areas do |t|
      t.references :decidim_assembly, null: false, index: false
      t.references :decidim_area, null: false, index: true
      t.timestamps
    end
    add_index :decidim_assemblies_areas, [:decidim_assembly_id, :decidim_area_id], unique: true, name: 'index_unique_assembly_and_area'

    create_table :decidim_participatory_processes_areas do |t|
      t.references :decidim_participatory_process, null: false, index: false
      t.references :decidim_area, null: false, index: true
      t.timestamps
    end
    add_index :decidim_participatory_processes_areas, [:decidim_participatory_process_id, :decidim_area_id], unique: true, name: 'index_unique_participatory_process_and_area'

    [
      Decidim::Suggestion,
      Decidim::Initiative,
      Decidim::Assembly,
      Decidim::ParticipatoryProcess
    ].each do |entity|
      entity.all.each do |s|
        next if s.decidim_area_id.blank?
        s.area_ids = [s.decidim_area_id]
        s.decidim_area_id = nil
        s.save
      end
    end

  end

  def down
    [
      Decidim::Suggestion,
      Decidim::Initiative,
      Decidim::Assembly,
      Decidim::ParticipatoryProcess
    ].each do |entity|
      entity.all.each do |s|
        next if s.area_ids.blank? || s.decidim_area_id.present?
        s.decidim_area_id = s.area_ids.first
        s.save
      end
    end

    drop_table :decidim_suggestions_areas
    drop_table :decidim_initiatives_areas
    drop_table :decidim_assemblies_areas
    drop_table :decidim_participatory_processes_areas
  end
end
