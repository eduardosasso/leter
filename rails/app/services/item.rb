class Item
  STATUS = {
    updated: 0,
    deleted: 1
  }.freeze

  attr_accessor :filename, :html, :status
end
