class CreateDogwalkings < ActiveRecord::Migration[5.2]
  def change
    create_table :dogwalkings do |t|
      t.integer :status
      t.datetime :schedule_date
      t.float :price
      t.integer :duration
      t.decimal :latitude
      t.decimal :longitude
      t.datetime :init_hour
      t.datetime :finish_hour
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
