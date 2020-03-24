class DogwalkingPet < ApplicationRecord
  belongs_to :pet
  belongs_to :dogwalking
end