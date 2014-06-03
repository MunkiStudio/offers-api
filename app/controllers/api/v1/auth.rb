# app/api/v1/auth.rb

module API
	module V1
		class Auth < Grape::API
			include API::V1::Defaults

			resource :auth do 
				desc "Login a user (return the token)"
				params do 
					requires :login, type: String, desc: "Username or email"
					requires :password, type: String, desc: "Password"
				end
				post :login do
					if params[:login].include?("@")
						user = User.find_by_email(params[:login].downcase)
					else
						user = User.find_by_username(params[:login].downcase)
					end
					if user && user.authenticate(params[:password])
						# key = ApiKey.create(user_id:user.id)
						{token: user.api_key.access_token,id:user.id}
					else
						error!('Unauthorized.',401)
					end
				end

				desc "Register a new user"
				# params do 
				# 	requires :password, type: String, desc: "Password for user"
				# 	requires :email, type: String, desc: "Email for user"
				# 	requires :username, type: String, desc: "Username"
				# end
				post :new do 
					email = params[:email]
					password = params[:password]
					username = params[:username]
					if email and password and username
						user = User.new(email:email,password:password,username:username)
						if user.save
							{token: user.api_key.access_token,id:user.id}
						else
							error!('Bad Params',400)
						end
					else
						error!('Bad Params',400)
					end
				end

				# get do 
				# 	{pong:"pong"}
				# end
			end
		end
	end
end