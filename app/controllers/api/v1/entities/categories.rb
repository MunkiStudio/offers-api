module API
	module V1
		module Entities
			class Categories < Grape::Entity
				# format_with(:iso_timestamp) { |dt| dt.iso8601 }
				expose :name
				expose :description
				expose :offers do |object, options|
					object.offers.as_json(:methods => [:thumb,:original])
				end
			end
		end
	end
end