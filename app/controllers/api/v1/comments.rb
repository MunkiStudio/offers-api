module API
	module V1
		class Comments < Grape::API
			include API::V1::Defaults
			resource :comments do 
				desc "Create a new comment for and offer form user"
				params do
					requires :comment, type: Hash do 
						requires :content, desc: "Content for the comment"
					end 
					requires :offer, type: Integer, desc: "Id for the offer where the comment will be published"
				end
				post do
					authenticate!
					comment = Comment.new(params[:comment].to_h)
					comment.user = current_user
					comment.offer_id = params[:offer]
					comment.save!
					present comment, with: API::V1::Entities::Comments, root:'objects'
					# if comment.save
					# 	present comment, with: API::V1::Entities::Comments, root:'objects'
					# else
					# 	error_response(message: "Can't save comment", status: 400)
					# end
				end
				
				desc "Return a list of comments from especific Offer"
				paginate :per_page => 10, :max_per_page => 10
				params do 
					requires :id, type: Integer, desc: "Id for the offer selected to see the comments"
				end
				get "offer/:id" do 
					authenticate!
					offer = Offer.find_by! id:params[:id]
					present paginate(offer.comments.includes(:user)), with: API::V1::Entities::Comments, root:'objects'
					
				end
			end
		end
	end
end