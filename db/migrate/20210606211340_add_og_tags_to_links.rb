# frozen_string_literal: true

class AddOgTagsToLinks < ActiveRecord::Migration[6.0]
  def change
    add_column :links, :og_tags, :text
  end
end
