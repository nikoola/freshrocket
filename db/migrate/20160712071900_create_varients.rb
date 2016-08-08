class CreateVarients < ActiveRecord::Migration
  def change
    create_table :varients do |t|
      t.belongs_to :option, index: true
      t.belongs_to :product, index: true
    end
  end
end
