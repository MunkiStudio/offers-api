require 'spec_helper'
describe API::V1 do
	describe 'Offers' do 
		
		let(:user) { FactoryGirl.create(:user) }
		let(:token) { user.api_key.access_token }
		let(:headers) { {
			'x-token' => user.api_key.access_token
			}
		}
		let(:categories) {FactoryGirl.create_list(:category,3)}

		it 'can publish a new offer' do 
			offer = FactoryGirl.attributes_for(:offer)
			offer[:category_ids] = []
			categories.each do |c|
				offer[:category_ids].push(c.id)
			end
			post '/api/v1/offers/',{:offer => offer},headers
			expect(response).to be_success
			get "/api/v1/offers/#{json['id']}",{},headers
			expect(response).to be_success 
			title = json['objects'][0]['title']
			expect(title).to eq(offer[:title])
			expect(json['objects'][0]['user']['id']).to eq(user.id)

		end

		it 'can get an offer identified by id' do 
			offer = FactoryGirl.create(:offer)
			get "/api/v1/offers/#{offer.id}",{},headers
			expect(response).to be_success
			expect(json['objects']['id']).to eq(offer.id)
		end

		

		it 'can delete my offers' do 
			user  = FactoryGirl.create(:user)
			offer = FactoryGirl.create(:offer,user:user)
			user2 = FactoryGirl.create(:user)
			offer2 = FactoryGirl.create(:offer,user:user2)
			#Login user
			post '/api/v1/auth/login',{:login => user.username,password:user.password}
			token = json['token']
			#Send delete
			delete "/api/v1/offers/#{offer.id}",{},{'x-token' => token}
			expect(response).to be_success
			get "/api/v1/offers/#{offer.id}",{},{'x-token' => token}
			expect(response.status).to be(404)
			delete "/api/v1/offers/#{offer2.id}",{},{'x-token' => token}
			expect(response.status).to be(404)

		end

		it 'can edit my offer' do 
			offer = FactoryGirl.attributes_for(:offer)
			post '/api/v1/offers/',{:token => token,:offer => offer}
			expect(response).to be_success
			offer[:title] = 'Title Edited'
			id = json['objects']['id']
			put "/api/v1/offers/#{id}",{:token => token,:offer => offer}
			expect(response).to be_success
			get "/api/v1/offers/#{id}",{:token => token}
			expect(json['objects']['title']).to eq(offer[:title])

			user  = FactoryGirl.create(:user)
			offer = FactoryGirl.create(:offer,user:user)
			put "/api/v1/offers/#{offer.id}",{:token => token,:offer => offer}
			expect(response.status).to eq(404)
		end
	end
end
