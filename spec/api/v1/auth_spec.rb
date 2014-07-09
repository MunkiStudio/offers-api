require 'spec_helper'
describe API::V1::Auth do
 
	
	context 'No authorization required' do 
		it 'create a new user (201)' do 
			data = {
				:email => Faker::Internet.email,
				:username => Faker::Internet.user_name,
				:password => Faker::Internet.password(8)       
			}
			post '/api/v1/auth/new', {:user => data}
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
				:birdthdate => DateTime.now.to_date,
				:localization => 'Talca'
			}
			post '/api/v1/auth/new', {:user => data}
			expect(response.status).to eq(201)
			expect(json['token']).not_to be_empty
			#If the user with fb_token exists
			user = FactoryGirl.attributes_for(:user)
			token = SecureRandom.hex
			user[:fb_token] = token
			user = User.create(user)
			data[:fb_token] = token 
			post '/api/v1/auth/new', {:user => data}
			expect(response).to be_success
			expect(json['token']).to eq(user.api_key.access_token)

		end

	end
	context 'Authorization required' do 
		before(:each) do 
			@user = {
				:email => Faker::Internet.email,
				:username => Faker::Internet.user_name,
				:password => Faker::Internet.password(8)       
			}
			post '/api/v1/auth/new', {:user => @user}
			@token = json['token']
		end


		it 'login with email and password' do 
			data = {
				:login => @user[:email],
				:password => @user[:password]
			}
			post '/api/v1/auth/login',{:user => data}
			expect(response.status).to eq(201)
			expect(json['token']).to eq(@token)
		end 

		it 'login with username and password' do 
			data = {
				:login => @user[:username],
				:password => @user[:password]
			}
			post '/api/v1/auth/login',{:user => data}
			expect(response.status).to eq(201)
			expect(json['token']).to eq(@token)
			data[:password] = 'passwordInvalida'
			post '/api/v1/auth/login',{:user => data }
			expect(response.status).to eq(401)
		end

		it 'login with fb_token' do 
			user = FactoryGirl.attributes_for(:user)
			token = SecureRandom.hex
			user[:fb_token] = token
			user = User.create(user)
			post '/api/v1/auth/fb_login',{fb_token:token}
			expect(response).to be_success
			expect(json['token']).to eq(user.api_key.access_token)
			post '/api/v1/auth/fb_login',{fb_token:'cualquier_token_que_no_existe'}
			expect(response.status).to eq(401)
			post '/api/v1/auth/fb_login'
			expect(response.status).to eq(500)
		end

		
		it 'with bad params' do 
			@user[:email] = 'thisIsBadEmail.com'
			post '/api/v1/auth/new',{:user => @user}
			expect(response.status).to eq(400)
			@user[:email] = 'Faker::Internet.email'
			@user[:password] = '123456'
			post '/api/v1/auth/new',{:user => @user}
			expect(response.status).to eq(400)
			user = {
				:email => @user[:email]
			}
			post '/api/v1/auth/new',{:user => user }
			expect(response.status).to eq(400)
		end
	end
end