class Notification < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
  belongs_to :where, polymorphic: true
  belongs_to :user
end
