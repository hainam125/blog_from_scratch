class Post < ActiveRecord::Base
  belongs_to :user
  
  has_many :votes, dependent: :destroy, as: :votable
  has_many :voting_users, through: :votes, source: :votable, source_type: "User"
  
  has_many :comments, as: :commentable, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 6}
  validates :content, presence: true, length: { minimum: 6}
  
  def vote_count(number)
	self.votes.where(value: number).size
  end
  
  def all_comments
    @all_comments ||= []
	current_comment = comments.to_a
	while (current_comment.any?)
	  comment = current_comment.shift
	  @all_comments << comment
	  current_comment += comment.comments if comment.comments.any?
	end
	@all_comments
  end
end