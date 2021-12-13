class Inventory < ApplicationRecord
  belongs_to :user
  belongs_to :item
  def self.getSell
    Item.joins(:inventories).where("inventories.status = 'sell'").select("items.id,items.name,items.rarity,inventories.id as iid, inventories.status, inventories.price, inventories.updated_at, inventories.user_id, items.url").order("inventories.updated_at DESC")
  end
end
