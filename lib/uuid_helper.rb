require "uuidtools"

module UUIDHelper
  def before_create
    self.uuid = UUIDTools::UUID.random_create.to_s
  end
end
