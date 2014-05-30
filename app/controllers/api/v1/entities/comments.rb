module API
	module V1
		module Entities
			class Comments < Grape::Entity
				format_with(:iso_timestamp) { |dt| dt.iso8601 }
				expose :content
				# expose :offer, using: `API::V1::Entities::Offers`, as: :offer
				# expose :user, using: `API::V1::Entities::Users`, as: :user
				expose :offer do |object,options|
					object.offer.as_json(:methods => [:thumb,:original])
				end
				expose :user do |object,options|
					object.user.as_json
				end
				with_options(format_with: :iso_timestamp) do
				  expose :created_at
				  expose :updated_at
				end

			end
		end
	end
end