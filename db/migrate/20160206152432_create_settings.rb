class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.decimal :tax_in_percentage,       precision: 4, scale: 2
      t.decimal :free_delivery_order_sum, precision: 8, scale: 2
      t.decimal :default_delivery_cost,   precision: 8, scale: 2
    end
  end
end
