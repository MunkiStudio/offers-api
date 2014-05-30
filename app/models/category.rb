class Category < ActiveRecord::Base
	has_and_belongs_to_many :offers

	validates :name, uniqueness: true, presence:true
end
