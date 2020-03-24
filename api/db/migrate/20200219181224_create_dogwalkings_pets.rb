class CreateDogwalkingsPets < ActiveRecord::Migration[5.2]
  def change
    create_table :dogwalking_pets do |t|
      t.belongs_to :pet, index: true
      t.belongs_to :dogwalking, index: true
    end
  end
end