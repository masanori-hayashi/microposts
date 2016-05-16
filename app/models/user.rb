class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
  validates :address, length: { maximum: 50 }
  validates :profile, length: { maximum: 50 }
  has_secure_password
  has_many :microposts
  # @user.microposts ← Micropost.where(user_id: @user.id)
  # @user.microposts.create({content: 'hogehoge'})
  # ↑ Micropost.create({content: 'hogehoge', user_id: @user.id})
    
  has_many :following_relationships, class_name:  "Relationship",
                                       foreign_key: "follower_id",
                                       dependent:   :destroy
  # @user.following_relationships ← Relationship.where(follower_id: @user.id)  
  has_many :following_users, through: :following_relationships, source: :followed
  # @user.following_users
  # followed_ids = []
  # Relationship.where(follower_id: @user.id).each do |r|
  #   followed_ids << r.followed_id
  # end
  # User.find(folowed_ids)
    
  has_many :follower_relationships, class_name:  "Relationship",
                                      foreign_key: "followed_id",
                                      dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower
  
  has_many :likes, dependent: :destroy
  
  has_many :like_microposts, through: :likes, class_name: 'Micropost'
  
  has_many :likes_microposts, through: :likes, source: :micropost
    
  # 他のユーザーをフォローする
  def follow(other_user)
      following_relationships.find_or_create_by(followed_id: other_user.id)
  end
    
  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end
    
  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end

  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end
  
  def like(micropost)
    likes.find_or_create_by(micropost_id: micropost.id)
  end
  
  def unlike(micropost)
    like = likes.find_by(micropost_id: micropost.id)
    like.destroy if like.present?
  end
  
  def like?(micropost)
    likes.find_by(micropost_id: micropost.id).present?
  end
end
