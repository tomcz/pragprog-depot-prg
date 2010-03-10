class CreateConversations < ActiveRecord::Migration

  def self.up
    create_table :conversations, :id => false do |t|
      t.string :uuid, :primary => true, :limit => 36
      t.string :context
      t.string :ref_id
      t.text :parameters
      t.timestamps
    end
    add_index :conversations, :ref_id
  end

  def self.down
    drop_table :conversations
  end

end
