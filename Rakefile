# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc "API Routes"
task :routes do
  API::V1::Base.routes.each do |api|
    method = api.route_method.ljust(10)
    path = api.route_path
    puts "     #{method} #{path}"
  end
end


desc "Delete old Offers"
task delete_old_offers: :environment do 
	Offer.where('updated_at <= ?', Time.now - 48.hours).each do |o|
		o.destroy
	end
end