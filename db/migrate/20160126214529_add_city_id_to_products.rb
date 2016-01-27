class AddCityIdToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :city, index: true, foreign_key: true
  end
end
