class CreateBse4pTrends < ActiveRecord::Migration
  def self.up
    create_table :bse4p_trends do |t|
      t.integer :bse_stock_id
      t.string :stock_name
      t.date :date
      t.integer :d30_t			#30 days trend
      t.integer :d_30_hi		#last highest occured in 30 days
      t.integer :d_30_li		#last lowest occured in 30 days
      t.integer :d_30_chi		#last close highest occured in 30 days
      t.integer :d_30_cli		#last close lowest occured in 30 days

      t.integer :d15_t			#30 days trend
      t.integer :d_15_hi		#last highest occured in 30 days
      t.integer :d_15_li		#last lowest occured in 30 days
      t.integer :d_15_chi		#last close highest occured in 30 days
      t.integer :d_15_cli		#last close lowest occured in 30 days

      t.integer :d7_t			#30 days trend
      t.integer :d_7_hi		#last highest occured in 30 days
      t.integer :d_7_li		#last lowest occured in 30 days
      t.integer :d_7_chi		#last close highest occured in 30 days
      t.integer :d_7_cli		#last close lowest occured in 30 days

      t.integer :d3_t			#30 days trend
      t.integer :d_3_hi		#last highest occured in 30 days
      t.integer :d_3_li		#last lowest occured in 30 days
      t.integer :d_3_chi		#last close highest occured in 30 days
      t.integer :d_3_cli		#last close lowest occured in 30 days

      t.integer :bs_signal
      t.float :last_close
      
      t.float :avg_high
      t.float :avg_low
      t.float :avg_close
      t.timestamps
    end
  end

  def self.down
  	drop_table :bse4p_trends
  end	
end
