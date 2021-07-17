class CreateFruits < ActiveRecord::Migration[6.1]
  def change
    create_table :fruits do |t|
      t.string :name
      t.string :color
      t.datetime :start_of_sales

      t.timestamps
    end
  end
end
