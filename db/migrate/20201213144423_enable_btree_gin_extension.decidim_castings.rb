# frozen_string_literal: true
# This migration comes from decidim_castings (originally 20201213140522)

class EnableBtreeGinExtension < ActiveRecord::Migration[5.2]
  def change
    return if extension_enabled?("btree_gin")

    begin
      enable_extension "btree_gin"
    rescue StandardError
      raise <<-MSG.squish
        Decidim castings module requires the btree_gin extension to be enabled in your PostgreSQL.
        You can do so by running `CREATE EXTENSION IF NOT EXISTS "btree_gin";` on the current DB as a PostgreSQL
        super user.
      MSG
    end
  end
end
