class CreateBseIndicesDumps < ActiveRecord::Migration
  def change
    create_table :bse_indices_dumps do |t|
    	t.integer :bse_indices_id
      t.date :date
	    t.float :open
	    t.float :high
	    t.float :low
	    t.float :close	    
    end
  end
end
