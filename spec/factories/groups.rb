# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    name {Faker::Lorem.words(2).join(" ")}
    description {Faker::Lorem.paragraph(3)}
    user_id ""
  end
end
