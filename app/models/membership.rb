class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :notifications, :as => :target
  has_many :notifications, :as => :object  

  before_create :set_owner_as_active
  after_create :create_notification

  private

  def create_notification
  	if self.group.user_id  != self.user_id
  		NotificationWorker.perform_async(self.id,'group')
  	end
  	
  end
  def set_owner_as_active
  	self.active = true
  end
end
