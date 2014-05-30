class Share < ActiveRecord::Base
  belongs_to :offer
  belongs_to :group
end
