# app/api/v1/auth.rb

module API
	module V1
		class Auth < Grape::API
			include API::V1::Defaults

			resource :auth do 
				post :fb_login do 
					if params[:fb_token]
						user = User.where(:fb_token => params[:fb_token]).first
						if user
							{token: user.api_key.access_token,id:user.id}
						else
							error!('Unauthorized',401)
						end
					else
						error!('Unauthorized',401)
					end
				end

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
				post :new do 
					if params[:fb_token]
						user = User.where(:fb_token => params[:fb_token]).first
						if user
							{token: user.api_key.access_token,id:user.id}
					else
						email = params[:email]
						password = if params[:password] then params[:password] else Faker::Internet.password(8) end
						username = params[:username]
						fb_token = params[:fb_token]

						if email and password and username
							user = User.new(email:email,password:password,username:username)
							if fb_token
								user.fb_token = fb_token
								user.first_name = params[:first_name]
								user.last_name = params[:last_name]
								user.gender    = params[:gender]
								user.age       = params[:age]
								user.localization = params[:localization]
							end
							if user.save
								{token: user.api_key.access_token,id:user.id}
							else
								error!('Bad Params',400)
							end
						else
							error!('Bad Params',400)
						end
					end
				end
			end
		end
	end
end