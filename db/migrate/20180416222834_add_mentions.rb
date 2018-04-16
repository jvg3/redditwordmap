class AddMentions < ActiveRecord::Migration

  def change
    create_table :mentions do |t|
      t.string :reddit_id
      t.string :body
      t.string :source
      t.string :url
      t.string :post_title
      t.timestamps null: false
    end
  end
end
