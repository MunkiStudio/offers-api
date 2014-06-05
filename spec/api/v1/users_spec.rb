# spec/api/v1/users_spec.rb
require 'spec_helper'
describe API::V1 do
 
	describe 'Users' do 
		describe 'With authorization' do 
			
			let(:user) { FactoryGirl.create(:user) }
			let(:token) { user.api_key.access_token }
			let(:headers) { {
				'x-token' => user.api_key.access_token
				}
			}
			it 'get me' do 
				get '/api/v1/users/me',{},headers
				expect(response.status).to eq(200)
				expect(json['objects']['id']).to eq(user[:id])
			end

			it 'get one user identified by id' do
				user = FactoryGirl.create(:user)
				get "/api/v1/users/#{user.id}",{},headers
				expect(response).to be_success
				expect(json['objects']['id']).to eq(user.id)
			end

			it 'get a list of paginated users' do 
				users = FactoryGirl.create_list(:user,10)
				get '/api/v1/users',{},headers
				expect(response).to be_success
				expect(json['objects'].length).to eq(10)
				
				expect(response.headers['X-Total-Pages']).to eq("2")
				expect(response.headers['X-Total']).to eq("11")
				get '/api/v1/users?page=2',{},headers
				expect(response.headers['X-Page']).to eq("2")
				
			end

			
		end
		describe 'Without authorization with false token' do 
			let(:headers) { {
				'x-token' => 'aaaaaaa'
				}
			}
			it 'get me' do 
				get '/api/v1/users/me',{},headers
				expect(response.status).to eq(401)
			end

			it 'sends one user identified by id' do 
				user = FactoryGirl.create(:user)
				get "/api/v1/users/#{user.id}",{},headers
				expect(response.status).to eq(401)
			end

			it 'sends a list of paginated users' do 
				users = FactoryGirl.create_list(:user,10)
				get '/api/v1/users',{},headers
				expect(response.status).to eq(401)
			end

		end

		describe 'Without authorization with no token' do 
			it 'get me' do 
				get '/api/v1/users/me'
				expect(response.status).to eq(401)
			end

			it 'get on user identified by id' do 
				user = FactoryGirl.create(:user)
				get "/api/v1/users/#{user.id}"
				expect(response.status).to eq(401)
			end

			it 'get a list of paginated users' do 
				users = FactoryGirl.create_list(:user,10)
				get '/api/v1/users'
				expect(response.status).to eq(401)
			end
		end
		
	end

	describe 'User offers' do 
		it 'get me with offers' do 
			user = FactoryGirl.create(:user_with_offers,offers_count: 5)
			user2 = FactoryGirl.create(:user_with_offers,offers_count:1)
			
			get '/api/v1/users/me',{:token => user.api_key.access_token}
			expect(response.status).to eq(200)
			expect(json['objects']['id']).to eq(user.id)
			expect(json['objects']['offers'].length).to eq(5)
			expect(json['objects']['offers'][0]['id']).not_to eq(user2.offers.first.id)
		end
	end
end	

