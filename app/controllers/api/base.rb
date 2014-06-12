# app/api/api.rb
require 'grape/rabl'
module API
	class Base < Grape::API
		mount API::V1::Base
		add_swagger_documentation(
	      base_path: "/api",
	      hide_documentation_path: true
	    )
	end
	
end