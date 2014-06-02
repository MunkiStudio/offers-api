module API
	module V1
		class Notifications < Grape::API
			include API::V1::Defaults
			resource :notifications do
				desc "Get paginated list of notifications"
				paginate :per_page => 10, :max_per_page => 10
				get do
					authenticate!
					present paginate(current_user.notifications), with: API::V1::Entities::Notifications,root:'objects'
				end
			end
		end
	end
end