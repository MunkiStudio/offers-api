class ApplicationController < ActionController
	def error_404
		render status: 404
	end

	def index
		render "index"
	end
end
