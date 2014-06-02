class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :offer
	has_many :notifications, :as => :target
	has_many :notifications, :as => :object

	after_create :create_notification

	private
	def create_notification
		NotificationWorker.perform_async(self.id,'comment')
	end
end
