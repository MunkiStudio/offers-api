# app/api/v1/base.rb

module API
	module V1
		class Base < Grape::API
			version 'v1', using: :path, vendor: 'munki', format: :json
			format :json
			formatter :json, Grape::Formatter::Rabl
			rescue_from :all, backtrace: true
			mount API::V1::Users
			mount API::V1::Auth
			mount API::V1::Offers
			mount API::V1::Comments
			mount API::V1::Categories
			mount API::V1::Groups
			mount API::V1::Notifications
			add_swagger_documentation base_path: "/api",api_version: 'v1',hide_documentation_path: false
			
		end
	end
end