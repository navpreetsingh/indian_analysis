class CreateBseStocks < ActiveRecord::Migration
  def change
    create_table :bse_stocks do |t|
      t.string :stock_name
      t.string :stock_full_name
      t.integer :vol_category     
      t.integer :price_category  
    end
  end
end
