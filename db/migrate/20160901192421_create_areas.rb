class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string 	:name
      t.decimal :radius
      t.integer :city_id
      t.boolean :active, default: true
      t.decimal :lat
      t.decimal :lng

      t.timestamps null: false
    end
  end
end
