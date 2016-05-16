class Micropost < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
  has_many :likes, dependent: :destroy
  
  has_many :users, through: :likes, source: :user
end
