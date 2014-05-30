class Group < ActiveRecord::Base
  has_many :memberships,:dependent => :delete_all
  has_many :users, :through => :memberships,:dependent => :delete_all
  has_many :shares,:dependent => :delete_all
  has_many :offers, :through => :shares,:dependent => :delete_all
  
  
end
