class SyndicationsSyndicationCategories < ActiveRecord::Migration
  def self.up
    create_table :syndications_syndication_categories, :id => false, :force => true do |t|
      t.integer :syndication_id
      t.integer :syndication_category_id
    end
  end

  def self.down
    drop_table :syndications_syndication_categories
  end
end
