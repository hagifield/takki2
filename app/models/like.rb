class Like < ApplicationRecord
    
  # ユーザーモデルとの関連付け: いいねはユーザーに属する
  belongs_to :user
  # いいね可能なモデル（投稿またはチケット）に属する
  belongs_to :likable, polymorphic: true
  
  # 通知とのポリモーフィック関連付け
  has_many :notifications, as: :notifiable, dependent: :destroy
end
