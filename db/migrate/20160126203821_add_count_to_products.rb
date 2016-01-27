class AddCountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :inventory_count, :integer
  end
end
