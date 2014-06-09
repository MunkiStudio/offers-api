# app/api/v1/users.rb
module API
	module V1
		class Users < Grape::API
			include API::V1::Defaults

			resource :users do 
				desc "Return paginated list of users"
				paginate :per_page => 10, :max_per_page => 10
				get do
					authenticate!
					users = User.includes(:notifications,:likes,:groups,:memberships).order(:id)
					present paginate(users), with: API::V1::Entities::Users,root:'objects'
					
				end

				desc "Return me data"
				get :me do 
					authenticate!
					present current_user, with: API::V1::Entities::Users,root:'objects'
					
				end

				desc "Return user data identified by id"
				params do 
					requires :id, type: Integer, desc: "ID of the User"
				end

				desc "Return a User identified by ID"
				params do 
					requires :id, type: Integer, desc: "Identificador del user"
				end
				get ":id" do
					authenticate!
					user = User.find(params[:id])
					present user, with: API::V1::Entities::Users,root:'objects'
					
				end


			end
		end
	end
end