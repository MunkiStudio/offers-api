require 'spec_helper'

describe API::V1 do 
	describe 'Groups' do 
		let(:user) { FactoryGirl.create(:user)}
		let(:headers) { {
			'x-token' => user.api_key.access_token
			}
		}
		it 'A User can create a group' do 
			group = FactoryGirl.attributes_for(:group,user_id:user.id)
			post '/api/v1/groups',{:group => group},headers
			expect(response).to be_success
			expect(Group.find(json['objects']['id']).memberships.count).to eq(user.memberships.count)
		end

		it 'Can get the groups owned by user identified by id' do
			FactoryGirl.create_list(:group,2,user_id:user.id)
			user2 = FactoryGirl.create(:user)
			FactoryGirl.create(:group,user_id:user2.id)
			get "/api/v1/groups/user/#{user.id}",{}, headers
			expect(response).to be_success
			expect(json['objects'].length).to eq(2)
			expect(json['objects'][0]['owner']['id']).to eq(user.id)
		end

		it 'Owner of a group can add new users to group' do 
			group = FactoryGirl.attributes_for(:group,user_id:user.id)
			group = user.groups.create(group)
			users = FactoryGirl.create_list(:user,3)
			data = {
				:user_ids => []
			}
			users.each do |u|
				data[:user_ids].push(u.id)
			end
			post "/api/v1/groups/#{group.id}",data,headers
			expect(response).to be_success
			expect(json['objects']['memberships'].length).to eq(4)
		end

		it 'Can get a group by id' do 
			group = FactoryGirl.attributes_for(:group,user_id:user.id)
			group = user.groups.create(group)
			get "/api/v1/groups/#{group.id}",{}, headers
			expect(response).to be_success
			expect(json['objects']['id']).to eq(group.id)
			expect(json['objects']['memberships'].length).to eq(1)
			get "/api/v1/groups/10",{},headers
			expect(response.status).to eq(404)
		end

		it 'Owner of a group can remove users from group' do
			group = FactoryGirl.attributes_for(:group,user_id:user.id)
			group = user.groups.create(group)
			users = FactoryGirl.create_list(:user,3)
			users.each do |u|
				group.memberships.create(:user_id => u.id)
			end
			data = {
				:user_ids => [users.first.id]
			}
			put "/api/v1/groups/#{group.id}",data,headers
			expect(response).to be_success
			expect(json['objects']['memberships'].length).to eq(3)
		end

		it 'Owner of a group can update the name and/or description' do 
			group = FactoryGirl.attributes_for(:group,user_id:user.id)
			group = user.groups.create(group)
			user2 = FactoryGirl.create(:user)
			data = {
				:attrs =>  { :name => "Nuevo nombre del Grupo",:description => "Nueva descripcion"}
			}
			put "/api/v1/groups/#{group.id}",data,headers
			expect(response).to be_success

			expect(json['objects']['name']).to eq(data[:attrs][:name])
			expect(json['objects']['description']).to eq(data[:attrs][:description])

			data2 = {
				:attrs =>  { :name => "Nuevo nombre del Grupo",:description => "Nueva descripcion"}
			}
			put "/api/v1/groups/#{group.id}",data,{'x-token' => user2.api_key.access_token}
			expect(response.status).to be(404)
		end

		it 'Owner of a group cand delete the group' do 
			group = FactoryGirl.attributes_for(:group,user_id:user.id)
			group = user.groups.create(group)
			count = Group.count
			delete "/api/v1/groups/#{group.id}",{},headers
			expect(response).to be_success
			expect(Group.count).to eq(count-1)
		end

		it 'Members of group can publish a Offer' do 
		end

	end
end