module API
	module V1
		module Entities
			class Users < Grape::Entity
				format_with(:iso_timestamp) { |dt| dt.iso8601 }
				expose :username
				expose :first_name
				expose :last_name
				expose :gender
				expose :birthdate
				expose :email
				expose :id
				expose :offers do |object,options|
					offers = Offer.where(:user => object)
					offers.as_json(:methods => [:thumb,:original])
				end
				expose :comments do |object,options|
					Comment.where(:user => object)
				end

				expose :notifications 
				expose :likes
				expose :groups
				expose :memberships

				with_options(format_with: :iso_timestamp) do
				  expose :created_at
				  expose :updated_at
				end

				

			end
		end
	end
end