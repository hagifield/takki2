class Comment < ApplicationRecord
  
  #バリデーション
  validates :content, presence: true
  
  # ユーザーモデルとの関連付け
  belongs_to :user
  # コメント可能なモデル（投稿、チケット）
  belongs_to :commentable, polymorphic: true
  
  # いいね機能とのポリモーフィック関連付け
  has_many :likes, as: :likeable, dependent: :destroy
  
  # 通知とのポリモーフィック関連付け
  has_many :notifications, as: :notifiable, dependent: :destroy
end
