class CreateNseIndicesDumps < ActiveRecord::Migration
  def change
    create_table :nse_indices_dumps do |t|
    	t.integer :nse_indices_id
      	t.date :date
	    t.float :open
	    t.float :high
	    t.float :low
	    t.float :close
	    t.integer :volume
    end
  end
end
