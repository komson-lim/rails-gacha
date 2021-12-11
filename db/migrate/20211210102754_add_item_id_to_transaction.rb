class AddItemIdToTransaction < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :item_id, :integer
  end
end
