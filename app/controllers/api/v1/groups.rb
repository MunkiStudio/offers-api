module API
	module V1
		class Groups < Grape::API
			include API::V1::Defaults
			resource :groups do 
				desc "Create a new group"
				params do 
					requires :group, type: Hash do 
						requires :name, type: String, desc: "Name or title for the comment"
						requires :description, desc: "Content for the comment"
						optional :user_id, desc: "ID for the owner"
					end
				end
				post do 
					authenticate!
					g = current_user.groups.create!(params[:group].to_h)
					present g, with: API::V1::Entities::Groups, root:'objects'
				end

				desc "Get the groups where the user identified by id are participating"
				params do 
					requires :id, type: Integer, desc: "ID for the user to get a list of his groups"
				end
				get "user/:id" do
					authenticate!
					groups = Group.includes(:users).where(:user_id => params[:id])
					present groups, with: API::V1::Entities::Groups, root:'objects'
				end

				desc "Let to the owner add new users to group"
				params do 
					requires :id, type: Integer, desc: "ID for the selected group"
					requires :user_ids, desc: "IDs (comma separated) for the users who will be added to the group"
				end
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
				params do 
					requires :id, type: Integer, desc: "ID of the group to be described"
				end
				get ":id" do
					authenticate!
					group = current_user.groups.find(params[:id])
					present group, with: API::V1::Entities::Groups, root:'objects'
				end

				desc "(owner) Can update the group, remove users or update other attributes"

				params do 
					requires :id, type: Integer, desc: "ID of the group to be updated"
					optional :user_ids, desc: "List of user_ids for the users who will be removed from the group"
					optional :attrs, desc: "Attributes from the group to be updated"
					mutually_exclusive :user_ids, :attrs
				end
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
				params do 
					requires :id, type: Integer, desc: "ID of the group to be deleted"
				end
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