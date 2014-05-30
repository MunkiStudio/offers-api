require 'spec_helper'
describe API::V1 do 
	describe 'Comments' do 
		describe 'With authorization' do 
			let(:user) { FactoryGirl.create(:user) }
			let(:token) { user.api_key.access_token }
			let(:data) { {token: token} }

			it 'create a comment for and offer' do 
				user2 = FactoryGirl.create(:user)
				offer = FactoryGirl.create(:offer,user:user2)
				comment = FactoryGirl.attributes_for(:comment)
				post '/api/v1/comments',{token:token,comment:comment,offer:offer.id}
				expect(response).to be_success
				expect(json['objects']['content']).to eq(comment[:content])
				expect(json['objects']['user']['id']).to eq(user.id)
				expect(json['objects']['offer']['id']).to eq(offer.id)
				expect(json['objects']['offer']['user_id']).to eq(user2.id)
			end

			it 'can get all comments from and offer' do 
				offer = FactoryGirl.create(:offer,user:user)
				offer2 = FactoryGirl.create(:offer,user:user)
				user2 = FactoryGirl.create(:user)
				FactoryGirl.create_list(:comment,3,user:user,offer:offer)
				FactoryGirl.create_list(:comment,2,user:user2,offer:offer)
				FactoryGirl.create_list(:comment,2,user:user2,offer:offer2)
				get "/api/v1/comments/offer/#{offer.id}",data
				expect(response).to be_success
				expect(json['objects'].length).to eq(5)
				get "/api/v1/comments/offer/#{offer2.id}",data
				expect(response).to be_success
				expect(json['objects'].length).to eq(2)
				get "/api/v1/comments/offer/300",data
				expect(response.status).to eq(404)
			end

			it 'can delete only my comments' do 
			end

			it 'can get one comment identified by id' do 
			end
		end
	end
end