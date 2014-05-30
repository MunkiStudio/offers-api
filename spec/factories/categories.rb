# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name {Faker::Lorem.words(1).join('')} 
    description {Faker::Lorem.paragraph}
  end
end
