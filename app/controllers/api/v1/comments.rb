module API
	module V1
		class Comments < Grape::API
			include API::V1::Defaults
			resource :comments do 
				desc "Create a new comment for and offer form user"
				
				post do
					authenticate!
					comment = Comment.new(params[:comment])
					comment.user = current_user
					comment.offer_id = params[:offer]
					if comment.save
						receive = Offer.find(params[:offer]).user #Offer
						if current_user != receive
							where   = Offer.find(params[:offer])
							verb    = 'New Comment'
							sender  = current_user
							API::V1::Workers::NotificationWorker.perform_async(sender,receive,where,verb)
						end
						present comment, with: API::V1::Entities::Comments, root:'objects'
					else
						error_response(message: "Can't save comment", status: 400)
					end
				end
				desc "Return a list of comments from especific Offer"

				paginate
				get "offer/:id" do 
					authenticate!
					offer = Offer.find_by! id:params[:id]
					present paginate(offer.comments), with: API::V1::Entities::Comments, root:'objects'
					
				end
			end
		end
	end
end