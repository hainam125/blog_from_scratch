class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  
  has_many :votes, dependent: :destroy, as: :votable
  has_many :voting_users, through: :votes, source: :votable, source_type: "User"
  
  validates :content, presence: true
  
  def vote_count(number)
	self.votes.where(value: number).size
  end
end
