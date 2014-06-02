class Notification < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
  belongs_to :target, :polymorphic => true
  belongs_to :object, :polymorphic => true
  
end
