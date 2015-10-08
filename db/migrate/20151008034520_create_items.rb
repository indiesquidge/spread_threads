class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :blurb
      t.string :author
      t.string :thumbnail_url
      t.string :details_url

      t.timestamps null: false
    end
  end
end
