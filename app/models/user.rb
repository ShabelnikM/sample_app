class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  'Relationship',
           foreign_key: :follower_id,
           dependent:   :destroy
  has_many :passive_relationships, class_name:  'Relationship',
           foreign_key: :followed_id,
           dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :comments, class_name: 'Comment', foreign_key: :commenter_id, dependent: :destroy
  ROLES = %w(admin moderator member)

  # Returns a user's status feed.
  def feed
    ids = following.pluck(:id)
    ids.push(id)
    Micropost.where(user_id: ids.compact.uniq)
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
end
