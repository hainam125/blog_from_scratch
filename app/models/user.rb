class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_create :downcase_email

  has_secure_password

  has_many :authoring_posts, class_name: "Post", dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :voting_posts, through: :votes, source: :votable, source_type: "Post"
  has_many :voting_comments, through: :votes, source: :votable, source_type: "Comment"
  has_many :active_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :passive_relationships

  EMAIL_REGEX = /\A[\w\-._]+@[a-z\d\-_]+(\.[a-z\d])*\.[a-z\d]+/i
  validates :username, presence: true, length: { minimum: 4, maximum: 50 }, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validates :password, length: { minimum: 6, maximum: 30 }

  def User.digest(token)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
	BCrypt::Password.create(token, cost: cost)
  end
  def User.create_token
	SecureRandom.urlsafe_base64
  end
  def create_remember
	self.remember_token = User.create_token
	update_attribute(:remember_digest, User.digest(remember_token))
  end
  def forget
	update_attribute(:remember_digest, nil)
  end

  def authenticate?(attribute, token)
	digest = send("#{attribute}_digest")
	return false if digest.nil?
	BCrypt::Password.new(digest).is_password?(token)
  end

  def vote_this?(resource)
	self.voting_comments.include?(resource) || self.voting_posts.include?(resource)
  end

  def follow_this(other)
	self.active_relationships.create(followed_id: other.id)
  end
  def unfollow_this(other)
	self.active_relationships.find_by(followed_id: other.id).destroy
  end
  def follow_this?(other)
	self.following.include?(other)
  end


  private
	def downcase_email
	  self.email = email.downcase
	end
end
