class CreateUsers < ActiveRecord::Migration

  def self.up
    create_table :users, :id => false do |t|
      t.string :uuid, :primary => true, :limit => 36
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end

end
