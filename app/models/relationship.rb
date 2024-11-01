class Relationship < ApplicationRecord
    
  # フォロワー（フォローする側）のユーザーとの関連付け
  belongs_to :follower, class_name: "User"
  
  # フォローされるユーザーとの関連付け
  belongs_to :followed, class_name: "User"
  
  # 通知とのポリモーフィック関連付け
  has_many :notifications, as: :notifiable, dependent: :destroy
  
  # フォロー関係のバリデーション: 同じ組み合わせのフォロー関係は一度だけ
  # フォロー解除後のフォローは可能
  validates :follower_id, uniqueness: { scope: :followed_id }
end
