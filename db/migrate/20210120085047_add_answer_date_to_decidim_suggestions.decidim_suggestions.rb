# frozen_string_literal: true
# This migration comes from decidim_suggestions (originally 20210120084949)

class AddAnswerDateToDecidimSuggestions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_suggestions, :answer_date, :date, null: true
  end
end
