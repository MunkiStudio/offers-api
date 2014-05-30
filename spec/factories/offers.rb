# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offer do
    latitude {Faker::Address.latitude}
    longitude {Faker::Address.longitude}
    title {Faker::Lorem.sentence(3)}
    description {Faker::Lorem.paragraph(2)}
    image {fixture_file_upload(Rails.root.join('spec','fixtures','test.png'),'image/png')}
    access_public true
    user
  end
end
