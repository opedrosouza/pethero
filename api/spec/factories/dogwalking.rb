FactoryBot.define do
  factory :dogwalking do
    status { 1 }
    schedule_date { Time.current }
    init_hour { Time.current }
    finish_hour { Time.current + 60.minute }
    duration { 2 }
    price { 60.0 }
    latitude { 0.0 }
    longitude { 0.0 }
    user
    pets { create_list(:pet, 2) }
  end
end