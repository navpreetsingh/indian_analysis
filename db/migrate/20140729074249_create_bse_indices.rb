class CreateBseIndices < ActiveRecord::Migration
  def change
    create_table :bse_indices do |t|
    	t.string :indices_name    	
    end
  end
end
