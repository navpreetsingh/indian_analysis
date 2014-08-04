class CreateNseWeekDetails < ActiveRecord::Migration
  def change
    create_table :nse_week_details do |t|
    	t.integer :nse_stock_id
    	t.year :year
    	t.float :open
    	t.float :high
    	t.float :low
    	t.float :close
      	t.integer :volume
	    t.integer :bs_signal
	    t.float :oh_diff
	    t.float :ol_diff
	    t.float :oc_diff      
    end
  end
end
