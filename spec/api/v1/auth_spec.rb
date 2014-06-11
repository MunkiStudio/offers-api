require 'spec_helper'
describe API::V1::Auth do
 
	
	context 'No authorization required' do 
		it 'create a new user (201)' do 
			data = {
				:email => Faker::Internet.email,
				:username => Faker::Internet.user_name,
				:password => Faker::Internet.password(8)       
			}
			post '/api/v1/auth/new', data
			expect(response.status).to eq(201)
			expect(json['token']).not_to be_empty
		end

		it 'create a new user with fb_token' do 
			data = {
				:fb_token => Faker::Bitcoin.address,
				:email => Faker::Internet.email,
				:username => Faker::Internet.user_name,
				:first_name => Faker::Name.first_name,
				:last_name => Faker::Name.last_name,
				:gender => 'male',
				:age => 28,
				:localization => 'Talca'
			}
			post '/api/v1/auth/new', data
			expect(response.status).to eq(201)
			expect(json['token']).not_to be_empty
		end

	end
	context 'Authorization required' do 
		before(:each) do 
			@user = {
				:email => Faker::Internet.email,
				:username => Faker::Internet.user_name,
				:password => Faker::Internet.password(8)       
			}
			post '/api/v1/auth/new', @user
			@token = json['token']
		end


		it 'login with email and password' do 
			data = {
				:login => @user[:email],
				:password => @user[:password]
			}
			post '/api/v1/auth/login',data 
			expect(response.status).to eq(201)
			expect(json['token']).to eq(@token)
		end 

		it 'login with username and password' do 
			data = {
				:login => @user[:username],
				:password => @user[:password]
			}
			post '/api/v1/auth/login',data 
			expect(response.status).to eq(201)
			expect(json['token']).to eq(@token)
		end

		it 'with bad params' do 
			@user[:email] = 'thisIsBadEmail.com'
			post '/api/v1/auth/new',@user 
			expect(response.status).to eq(400)
			@user[:email] = 'Faker::Internet.email'
			@user[:password] = '123456'
			post '/api/v1/auth/new',@user 
			expect(response.status).to eq(400)
			user = {
				:email => @user[:email]
			}
			post '/api/v1/auth/new',user 
			expect(response.status).to eq(400)
		end
	end
end