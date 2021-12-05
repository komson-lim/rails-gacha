class Item < ApplicationRecord
    has_many :banner_items
    has_many :banner, through: :banner_items
    has_many :inventories
    has_many :users, through: :inventories
end
