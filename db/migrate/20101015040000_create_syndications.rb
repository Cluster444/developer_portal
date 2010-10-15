class CreateSyndications < ActiveRecord::Migration
  def self.up
    create_table :syndications, :force => true do |t|
      t.string :title
      t.text :description
      t.string :url
      t.string :protocol
      t.string :content_type
      t.integer :category_id
      t.boolean :spam, :default => false
      t.string :state, :default => nil

      t.timestamps
    end
    
    add_index :syndications, :id

    load(Rails.root.join('db', 'seeds', 'syndication.rb').to_s)
  end

  def self.down
    UserPlugin.destroy_all({:name => "syndication"})
    Page.delete_all({:link_url => "/feeds"})

    drop_table :syndications
  end
end
