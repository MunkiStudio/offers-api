# app/api/v1/auth.rb

module API
	module V1
		class Auth < Grape::API
			include API::V1::Defaults

			resource :auth do 
				desc "Login a user using the user_id obtained from Facebook, return the token"
				params do 
					requires :fb_token, type: String, desc: "uid from Facebook"
				end
				post :fb_login do 
					if params[:fb_token]
						user = User.where(:fb_token => params[:fb_token]).first
						if user
							{token: user.api_key.access_token,id:user.id}
						else
							error!('Unauthorized',401)
						end
					end
				end

				desc "Login a user using email|username and password, return the token"
				params do 
					requires :login, type: String, desc: "Username or email"
					requires :password, type: String, desc: "Password"
				end
				post :login do
					user = User.where("username = ? OR email = ?", params[:login],params[:login]).first
					if user && user.authenticate(params[:password])
						{token: user.api_key.access_token,id:user.id}
					else
						error!('Unauthorized.',401)
					end
				end

				desc "Register a new user, return the token. If the fb_token is given, the API return the user if exists or register the new user with facebook data"
				params do
					requires :email, 	type: String, desc: "User email"
					optional :password, type: String, desc: "Optional if fb_token is given"
					optional :username, type: String, desc: "Optional if fb_token is given"
					optional :fb_token,	type: String, desc: "uid from Facebook"
					optional :first_name, type: String, desc: "First name of the user (from Facebook)"
					optional :last_name, type: String, desc: "Last name of the user (from Facebook)"
					optional :gender, type: String, desc: "Gender of the user (from Facebook)"
					optional :age, type: Integer, desc: "Age of the user (from Facebook)"
					optional :location, type: String, desc: "Localization of the user (from Facebook)"
				end
				post :new do 
					params[:password] = if params[:password] then params[:password] else SecureRandom.hex(8) end
					register = true
					if fb_token 
						user = User.where(:fb_token => params[:fb_token]).first
						if user 
							register = false
							return {token: user.api_key.access_token,id:user.id}
						end
						
					end
					if register
						if email and password and username
							user = User.new(params)
							if user.save
								return {token: user.api_key.access_token,id:user.id}
							else
								error!(user.errors.full_messages,400)
							end
						else
							error!('Falta email, password o username',400)
						end
					end
				end
			end
		end
	end
end