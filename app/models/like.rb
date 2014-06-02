class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :offer

  has_many :notifications, :as => :target
  has_many :notifications, :as => :object
end
