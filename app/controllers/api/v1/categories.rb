module API
	module V1
		class Categories < Grape::API
			include API::V1::Defaults
			resource :categories do 
				desc "Get the paginated list of categories and offers associated"
				paginate
				get do 
					authenticate!
					categories = Category.order(:name)
					present paginate(categories), with: API::V1::Entities::Categories, root:'objects'
					
				end

				get ":id" do 
					authenticate!
					category = Category.where('id = ? or name = ?', params[:id], params[:id]).first
					present category, with: API::V1::Entities::Categories, root:'objects'
				end

				
			end
		end
	end
end