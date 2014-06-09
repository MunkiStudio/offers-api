module API
	module V1
		class Groups < Grape::API
			include API::V1::Defaults
			resource :groups do 
				desc "Create a new group"
				post do 
					authenticate!
					g = current_user.groups.create!(params[:group].to_h)
					present g, with: API::V1::Entities::Groups, root:'objects'
				end

				desc "Get the groups where the user identified by id are participating"
				get "user/:id" do
					authenticate!
					groups = Group.includes(:users).where(:user_id => params[:id])
					present groups, with: API::V1::Entities::Groups, root:'objects'
				end

				desc "Let to the owner add new users to group"
				post ":id" do
					authenticate!
					user_ids = params[:user_ids]
					group = current_user.groups.find(params[:id])
					if group
						user_ids.each do |u|
							group.memberships.create(:user_id => u)
						end
						present group, with: API::V1::Entities::Groups, root:'objects'
					end
				end

				desc "(owner) Return a description of the group identified by id"
				get ":id" do
					authenticate!
					group = current_user.groups.find(params[:id])
					present group, with: API::V1::Entities::Groups, root:'objects'
				end

				desc "(owner) Can update the group, remove users or update other attributes"
				put ":id" do 
					authenticate!
					group = current_user.groups.find(params[:id])
					if params[:user_ids]
						params[:user_ids].each do |u| 
							group.memberships.find_by(:user_id => u).delete
						end
					elsif params[:attrs]
						group.update params[:attrs].to_h
					end		
					present group, with: API::V1::Entities::Groups, root:'objects'
				end

				desc "(owner) Cand delete the group"
				delete ":id" do 
					authenticate!
					group = current_user.groups.find(params[:id])
					group.destroy if group
					""	
				end

			end
		end
	end
end