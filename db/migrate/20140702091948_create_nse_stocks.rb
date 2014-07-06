class CreateNseStocks < ActiveRecord::Migration
  def change
    create_table :nse_stocks do |t|
      t.string :stock_name
      t.integer :vol_category      
    end
  end
end
