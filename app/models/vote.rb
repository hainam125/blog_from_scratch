class Vote < ActiveRecord::Base
  belongs_to :voting_user, class_name: "User", foreign_key: :user_id
  
  belongs_to :votable, polymorphic: true
  
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
end
