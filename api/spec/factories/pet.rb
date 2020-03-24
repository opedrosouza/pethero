FactoryBot.define do
  factory :pet do
    name { 'Lupita' }
    age  { 1 }
    breed { 'vira-lata' }
    size { 1 }
    gender { 1 }
    user
  end
end