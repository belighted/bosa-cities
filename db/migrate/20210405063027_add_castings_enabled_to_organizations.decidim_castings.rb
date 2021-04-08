# frozen_string_literal: true
# This migration comes from decidim_castings (originally 20210402155523)

class AddCastingsEnabledToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_organizations, :castings_enabled, :boolean
  end
end
