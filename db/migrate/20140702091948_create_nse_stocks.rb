class CreateNseStocks < ActiveRecord::Migration
  def change
    create_table :nse_stocks do |t|
      t.string :stock_name
      t.integer :vol_category   
      t.integer :price_category   
      t.integer :useless_stock
    end
  end
end
