module API
	module V1
		class Comments < Grape::API
			include API::V1::Defaults
			resource :comments do 
				desc "Create a new comment for and offer form user"
				post do
					authenticate!
					comment = Comment.new(params[:comment].to_h)
					comment.user = current_user
					comment.offer_id = params[:offer]
					if comment.save
						present comment, with: API::V1::Entities::Comments, root:'objects'
					else
						error_response(message: "Can't save comment", status: 400)
					end
				end
				
				desc "Return a list of comments from especific Offer"
				paginate :per_page => 10, :max_per_page => 10
				get "offer/:id" do 
					authenticate!
					offer = Offer.find_by! id:params[:id]
					present paginate(offer.comments), with: API::V1::Entities::Comments, root:'objects'
					
				end
			end
		end
	end
end