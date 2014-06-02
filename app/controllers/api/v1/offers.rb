# app/api/v1/offer.rb
module API
	module V1
		class Offers < Grape::API
			include API::V1::Defaults
			resource :offers do
				desc "Return paginated list of offers"
				paginate :per_page => 10, :max_per_page => 10
				get do 
					authenticate!
					offers = Offer.order(:id)
					present paginate(offers), with: API::V1::Entities::Offers, root:'objects'
				end

				desc "Create a new offer"
				params do 
					requires :offer, type: Hash, desc: "Offer attributes"
				end
				post do 
					authenticate!
					image = params[:offer][:image]
					offer = params[:offer].except(:image)
					hash = {}
					image.instance_variables.each {|var| hash[var.to_s.delete("@")] = image.instance_variable_get(var)}
					offer.image = ActionDispatch::Http::UploadedFile.new(image)
					offer = current_user.offers.create!(params[:offer])
					present  offer, with: API::V1::Entities::Offers, root:'objects'

				end

				desc "Return an Offer identified by ID"
				params do 
					requires :id, type: Integer, desc: "Identificador del offer"
				end
				get ":id" do
					authenticate!
					offer = Offer.find(params[:id])
					present offer, with: API::V1::Entities::Offers,root:'objects'
				end

				desc "Delete an Offer identified by ID"
				params do 
					requires :id, type: Integer, desc: "Identificador del offer"
				end
				delete ":id" do 
					authenticate!
					offer = Offer.where(user_id:current_user.id).find(params[:id])
					if offer
						offer.delete
						""	
					else
						error_response(message: e.message, status: 404)
					end
				end

				desc "Update an Offer identified by ID"
				params do 
					requires :id, type: Integer, desc: "Identificador del offer"
				end
				put ':id' do
					authenticate!
					offer = Offer.where(user_id:current_user.id).find(params[:id])
					if offer
						offer.update params[:offer].except(:id)
						""
					else
						error_response(message: e.message, status: 404)
					end
				end

			end
		end
	end
end