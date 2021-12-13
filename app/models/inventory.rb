class Inventory < ApplicationRecord
  belongs_to :user
  belongs_to :item
  validates_numericality_of :price, :greater_than_or_equal_to =>0 , message: "Cannot be negative number"
  def self.getSell
    Item.joins(:inventories).where("inventories.status = 'sell'").select("items.id,items.name,items.rarity,inventories.id as iid, inventories.status, inventories.price, inventories.updated_at, inventories.user_id, items.url").order("inventories.updated_at DESC")
  end
end
