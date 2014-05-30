class User < ActiveRecord::Base
	validates :username, presence: true
	validates :password, presence: true
	validates :email, presence: true

	validates :email, uniqueness: true
	validates :password, length:{minimum: 8}

	has_secure_password
	has_one :api_key
	has_many :offers
	has_many :comments , :dependent => :destroy
	has_many :groups, :through =>  :memberships
	has_many :memberships, :dependent => :destroy
	has_many :notifications
	has_many :likes
	has_many :liked_offers, :through => :likes, :source => :offer
	
	# attr_accessible :email, :username, :password

	after_create :generate_token
	before_save { self.email = email.downcase }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  	validates :email, format: { with: VALID_EMAIL_REGEX }

  	def as_json(options={})
  		super(options.merge({except:[:password,:password_digest]}))
  	end

  	def total_comments
  		self.comments.count
  	end

  	def total_offers
  		self.offers.count
  	end


	private
	def generate_token
		self.create_api_key()
	end
end
