class CreateLineItems < ActiveRecord::Migration

  def self.up
    create_table :line_items, :id => false do |t|
      t.string :uuid, :primary => true, :limit => 36, :null => false
      t.string :product_id, :null => false, :options => "CONSTRAINT fk_line_item_products REFERENCES products(uuid)"
      t.string :order_id, :null => false, :options => "CONSTRAINT fk_line_item_orders REFERENCES orders(uuid)"
      t.integer :quantity,	:null => false
      t.decimal :total_price, :null => false, :precision => 8, :scale => 2
      t.timestamps
    end
    execute("ALTER TABLE line_items ADD PRIMARY KEY (uuid)")
  end

  def self.down
    drop_table :line_items
  end

end
