module API
	module V1
		module Entities
			class Groups < Grape::Entity
				# format_with(:iso_timestamp) { |dt| dt.iso8601 }
				expose :id
				expose :name
				expose :description
				expose :owner do |object, options|
					User.find(object.user_id).as_json
				end
				expose :offers do |object, options|
					object.offers.includes(:offers).as_json(:methods => [:thumb,:original])
				end
				expose :memberships do |object,options|
					object.users.as_json
				end
			end
		end
	end
end