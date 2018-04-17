class AddNounsToMentions < ActiveRecord::Migration
  def change
    add_column :mentions, :nouns, :text, array: true, default: []
  end
end
