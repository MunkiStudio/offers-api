# app/api/base.rb
require 'grape/rabl'
require 'grape-swagger'
module API
	class Base < Grape::API
		mount API::V1::Base
	end
	# Base = Rack::Builder.new do
	#     use API::Logger
	#     run API::Dispatch
	# end
end