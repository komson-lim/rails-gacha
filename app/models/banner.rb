class Banner < ApplicationRecord
    has_many :banner_items
    has_many :items, through: :banner_items
    has_many :likes
    has_many :users, through: :likes
    def getItem()
        Item.joins(:banner_items).where("banner_items.banner_id = #{self.id}").select("items.id, items.name, items.rarity, banner_items.rate")
    end
    def getRate()
        Item.joins(:banner_items).where("banner_items.banner_id = #{self.id}").pluck("items.id, banner_items.rate")
    end
end
