class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
#バリデーション
  with_options presence: true do
    validates :name
    validates :email, uniqueness: true
    validates :password, length: {minimum: 6}, if: :password_required?
  end
  
  validates :introduction, length: {maximum: 300}
  
# Active Storage設定: ユーザーのプロフィール画像
  has_one_attached :profile_image
  
# コメントモデル関連付け       
  has_many :comments, dependent: :destroy
  
#投稿モデル関連付け
  has_many :posts, dependent: :destroy
  
#チケットモデル関連付け
  # ユーザーが発行したチケットとの関連付け
  has_many :issued_tickets, class_name: "Ticket", foreign_key: "issuer_id", dependent: :destroy

  # ユーザーが受け取ったチケットとの関連付け
  has_many :received_tickets, class_name: "Ticket", foreign_key: "recipient_id", dependent: :destroy
  
  
# 所有権モデル関連付け
  has_many :ownerships, dependent: :destroy
  
  # 所有しているチケットを取得するための関連付け
  has_many :owned_tickets, through: :ownerships, source: :ticket
  
# いいね機能の関連付け（ポリモーフィック）
  has_many :likes, dependent: :destroy
  
# 通知モデルとの関連付け
  has_many :notifications, dependent: :destroy

#フォロー関連 
  # 自分がフォローしているユーザーとの関連付け。
  # 自分（follower_id）が他のユーザー（followed_id）をフォローしている関係。
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  
  # 自分をフォローしているユーザーとの関連付け。
  # 他のユーザーが自分（followed_id）をフォローしている関係
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  # 自分がフォローしているユーザーを取得
  has_many :followings, through: :active_relationships, source: :followed
  
  # 自分をフォローしているユーザーを取得
  has_many :followers, through: :passive_relationships, source: :follower
  
  # 指定したユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end
  
  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end
  
  # 指定したユーザーをフォローしているかどうかを判定
  def following?(user)
    followings.include?(user)
  end
  
  
  private

  def password_required?
    new_record? || password.present?
  end
end
