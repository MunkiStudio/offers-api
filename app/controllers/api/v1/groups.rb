module API
	module V1
		class Groups < Grape::API
			include API::V1::Defaults
			resource :groups do 
				desc "Create a new group"
				post do 
					authenticate!
					g = current_user.groups.create!(params[:group])
					present g, with: API::V1::Entities::Groups, root:'objects'
				end

				desc "Get the groups where the user identified by id are participating"
				get "user/:id" do
					authenticate!
					groups = Group.where(:user_id => params[:id])
					present groups, with: API::V1::Entities::Groups, root:'objects'
				end

				desc "Let to the owner add new users to group"
				post ":id" do
					authenticate!
					user_ids = params[:user_ids]
					group = current_user.groups.find(params[:id])
					if group
						verb = 'NEW_GROUP'
						sender = current_user
						user_ids.each do |u|
							group.memberships.create(:user_id => u)
							receive = User.find(u)
							API::V1::Workers::NotificationWorker.perform_async(sender,receive,nil,verb)
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
						verb = 'DELETED_FROM_GROUP'
						sender = current_user
						params[:user_ids].each do |u| 
							group.memberships.find_by(:user_id => u).delete
							#Notificar que se me elimino del grupo
							receive = User.find(u)
							NotificationWorker.perform_async(sender,receive,nil,verb)
						end
					elsif params[:attrs]
						group.update params[:attrs]
					end		
					present group, with: API::V1::Entities::Groups, root:'objects'
				end

				desc "(owner) Cand delete the group"
				delete ":id" do 
					authenticate!
					group = current_user.groups.find(params[:id])
					if group
						group.destroy
						#Notificar eliminacion del grupo
					end
					""	
				end

			end
		end
	end
end