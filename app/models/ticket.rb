class Ticket < ApplicationRecord
  # チケットの状態を管理するenum
  enum status: { unused: 0, used: 1, unusable: 2 }

  # 発行者と受取人の関連付け
  belongs_to :issuer, class_name: "User", foreign_key: "issuer_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id", optional: true

  # 所有権モデルとの関連付け
  has_many :ownerships, dependent: :destroy
  has_many :owners, through: :ownerships, source: :user

  # 投稿モデルとの関連付け: チケットは投稿に含まれる場合がある
  belongs_to :post, optional: true

  # Active Storage設定: チケットのQRコード
  has_one_attached :qr_code

  # いいね機能の設定
  has_many :likes, as: :likable, dependent: :destroy

  # チケットに対するコメント
  has_many :comments, as: :commentable, dependent: :destroy

  # 通知とのポリモーフィック関連付け
  has_many :notifications, as: :notifiable, dependent: :destroy

  # バリデーション
  validates :name, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  # デフォルト値の設定
  before_create :set_defaults

  private

  def set_defaults
    self.status ||= :unused
    self.private ||= false
  end
end
