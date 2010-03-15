class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products, :id => false do |t|
      t.string :uuid, :primary => true, :limit => 36, :null => false
      t.string :title
      t.text :description
      t.string :image_url
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
