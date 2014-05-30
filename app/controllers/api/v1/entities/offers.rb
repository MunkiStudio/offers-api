module API
	module V1
		module Entities
			class Offers < Grape::Entity
				# format_with(:iso_timestamp) { |dt| dt.iso8601 }
				expose :latitude
				expose :longitude
				expose :title
				expose :description
				expose :id
				expose :access_public
				expose :thumb do |object, options|
					object.image.url(:thumb)
				end
				
				expose :original do |object, options|
					object.image.url
				end

				expose :user do |object, options|
					object.user.as_json
				end
				expose :comments do |object,options|
					Comment.where(:offer => object)
				end
				expose :categories do |object,options|
					object.categories
				end
				expose :created_at
				expose :updated_at
				# end

			end
		end
	end
end