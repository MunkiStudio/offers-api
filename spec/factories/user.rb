FactoryGirl.define do
	factory :user do
		first_name 	{Faker::Name.first_name}
		last_name  	{Faker::Name.last_name}
		email		{Faker::Internet.email}
		username   	{Faker::Internet.user_name}
		password   	{Faker::Internet.password(8)}
		gender 		"Male"
		birthdate	DateTime.now.to_date
		factory :user_with_offers do 
			ignore do
				offers_count 5
			end
			after(:create) do |user, evaluator|
				create_list(:offer,evaluator.offers_count,user:user)
			end
		end
	end
end
