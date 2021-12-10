class User < ApplicationRecord
    has_secure_password
    validates :username, uniqueness: true
    has_many :likes
    has_many :banners, through: :likes
    has_many :inventories
    has_many :items, through: :inventories
    def isCorrectUser
        self.id == session[:user_id]
    end
    def check_password(password)
        if (self.password == password)
            return true
        else
            errors.add(:password, "doesn't match")
            return false
        end
    end
    def getInventory
        Item.joins(:inventories).where("inventories.user_id = #{self.id}").select("items.id,items.name,items.rarity,inventories.id as iid, inventories.status, inventories.price, inventories.created_at").order("inventories.created_at DESC")
    end
end
