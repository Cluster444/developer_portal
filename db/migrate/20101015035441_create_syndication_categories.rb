class CreateSyndicationCategories < ActiveRecord::Migration
  def self.up
    create_table :syndication_categories, :force => true do |t|
      t.string :title
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :syndication_categories
  end
end
