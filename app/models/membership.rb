class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  after_create :set_owner_as_active


  private


  def set_owner_as_active
  	g = Group.where(:user_id => self.user_id, :id => self.group_id).first
  	if g
  		self.update(active:true)
  	end
  end
end
