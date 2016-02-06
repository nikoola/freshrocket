class AddTimesToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_date, :date
    add_column :orders, :delivery_time, :string
  end
end
