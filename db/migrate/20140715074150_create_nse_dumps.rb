class CreateNseDumps < ActiveRecord::Migration
  def change
    create_table :nse_dumps do |t|
			t.integer :nse_stock_id
      t.date :date
      t.float :open
      t.float :high
      t.float :low
      t.float :close
      t.integer :volume
      t.float :turnover
    end
  end
end
