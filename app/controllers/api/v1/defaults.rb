# app/controllers/api/v1/defaults.rb

module API
	module V1
		module Defaults
			extend ActiveSupport::Concern

			included do
				include Grape::Kaminari
				
				
				# global handler for simple not found case
				rescue_from ActiveRecord::RecordNotFound do |e|
					error_response(message: e.message, status: 404)
				end

				#global exception handler, used for error notifications
				rescue_from :all do |e|
					if Rails.env.development?
						raise e
					else
						#Raven.capture_exception(e)
						# logger.error e.message
						error_response(message: "Internal server error #{e.message}", status: 500)
					end
				end

				
				helpers do 
					def authenticate!
						error!("Unauthorized. Invalid token",401) unless current_user
					end

					def current_user
						access_token = params[:token] || headers['X-Token']
						
						token = ApiKey.where(access_token: access_token).first
						if token and !token.expired?
							@current_user = User.find(token.user_id)
						else
							false
						end
					end

					def user_params
						ActionController::Parameters.new(params).require(:user).permit(:email,:password,:username,:fb_token,:first_name,:last_name,:gender,:birthdate,:localization)
					end

					
				end
			end
		end
	end
end