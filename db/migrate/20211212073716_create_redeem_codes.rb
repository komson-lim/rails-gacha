class CreateRedeemCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :redeem_codes do |t|
      t.string :code
      t.integer :amount
      t.string :status

      t.timestamps
    end
  end
end
