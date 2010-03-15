class CreateOrders < ActiveRecord::Migration

  def self.up
    create_table :orders, :id => false do |t|
      t.string :uuid, :primary => true, :limit => 36, :null => false
      t.string :name
      t.text :address
      t.string :email
      t.string :pay_type, :limit => 10
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end

end
