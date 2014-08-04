class CreateNseMonthDetails < ActiveRecord::Migration
  def change
    create_table :nse_month_details do |t|
    	t.integer :nse_stock_id
    	t.string :date
    	t.float :open
    	t.float :high
    	t.float :low
    	t.float :close
      t.integer :volume
	    t.integer :bs_signal
	    t.float :oh_diff
	    t.float :ol_diff
	    t.float :oc_diff    
      t.date :date1
    end
  end
end
