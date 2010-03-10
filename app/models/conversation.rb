class Conversation < ActiveRecord::Base

  set_primary_key :uuid
  include UUIDHelper

  serialize :parameters

  def self.get_or_create(uuid)
    if uuid.to_s == 'new'
      self.new
    else
      conversation = self.find_by_uuid(uuid)
      unless conversation
        conversation = self.new
      end
      conversation
    end
  end

  def self.destroy_if_exists(uuid)
    if uuid.to_s != 'new' and self.exists? uuid
      self.destroy uuid
    end
  end

end
