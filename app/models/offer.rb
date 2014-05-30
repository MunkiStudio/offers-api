class Offer < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_and_belongs_to_many :categories
  has_many :groups, :through => :shares
  has_many :shares

  has_many :likes
  has_many :liking_users, :through => :likes, :source => :user
  
  has_attached_file :image, :styles => {:thumb => "100x100>"}
  validates_attachment_content_type :image, :content_type => /\Aimage/
  validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/]
  reverse_geocoded_by :latitude, :longitude

  def as_json(options={})
  	super(options.merge({except:[:image_file_name,:image_content_type,:image_file_size,:image_updated_at]}))
  end

  def thumb
  	self.image.url(:thumb)
  end

  def original
  	self.image.url
  end

  def total_comments
    self.comments.count
  end

  
end
