class Ticket < ApplicationRecord
    
#チケットステータスのenum設定
  enum status: { unused: 0, used: 1, unusable: 2 }
  
  #バリデーション
  with_options presence: true do
    validates :name
    validates :description
    validates :expiration_date
    validates :quantity
    validates :available_quantity
    validates :status
  end
  
  # 所有権モデルとの関連付け
  has_many :ownerships, dependent: :destroy
  # チケットの所有者を取得
  has_many :owners, through: :ownerships, source: :user

  # 投稿モデルとの関連付け: チケットは投稿に含まれる
  belongs_to :post, optional: true

  # Active Storage設定: チケットのQRコード
  has_one_attached :qr_code

  # いいね機能の設定
  has_many :likes, as: :likable, dependent: :destroy

  # チケットに対するコメント
  has_many :comments, as: :commentable, dependent: :destroy
  
  # 通知とのポリモーフィック関連付け
  has_many :notifications, as: :notifiable, dependent: :destroy
end
