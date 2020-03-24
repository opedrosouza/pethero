class Pet < ApplicationRecord
  belongs_to :user
  has_many :dogwalking_pets
  has_many :dogwalkings, through: :dogwalking_pets

  validates_presence_of :name, :age, :gender, :breed, :size, :user_id
end
