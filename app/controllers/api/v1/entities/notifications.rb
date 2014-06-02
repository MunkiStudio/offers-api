module API
	module V1
		module Entities
			class Notifications < Grape::Entity
				expose :sender do |object, options|
					object.sender.as_json
				end

				expose :recipient do |object,options|
					object.recipient.as_json
				end
				expose :target do |object,options|
					object.target.as_json
				end
				expose :object do |object,options|
					object.object.as_json
				end
				expose :verb
				expose :created_at
				expose :updated_at
			end
		end
	end
end