class CreateNseIndices < ActiveRecord::Migration
  def change
    create_table :nse_indices do |t|
	    t.string :indices_name  
    end
  end
end
