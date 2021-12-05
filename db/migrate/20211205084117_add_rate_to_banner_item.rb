class AddRateToBannerItem < ActiveRecord::Migration[6.1]
  def change
    add_column :banner_items, :rate, :decimal
  end
end
