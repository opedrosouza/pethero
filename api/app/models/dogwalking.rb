class Dogwalking < ApplicationRecord
  belongs_to :user
  has_many :dogwalking_pets
  has_many :pets, through: :dogwalking_pets

  validates_presence_of :schedule_date, :init_hour, :finish_hour, :duration, :price, :latitude, :longitude

  scope :since_today, lambda {where("schedule_date > ?", Time.current)}
  
end
