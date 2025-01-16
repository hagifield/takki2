class Ticket < ApplicationRecord
  # ステータスをenumで設定
  enum status: { active: 0, inactive: 1 }

  # 発行者と受取人の関連付け
  belongs_to :issuer, class_name: "User", foreign_key: "issuer_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id", optional: true

  # 個別チケットモデルとの関連付け
  has_many :individual_tickets, dependent: :destroy

  # 投稿モデルとの関連付け
  belongs_to :post, optional: true

  # Active Storage設定
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

  # デフォルト値を設定
  after_initialize :set_default_status, if: :new_record?
  
  # 残り枚数を計算するメソッド
  def remaining_tickets
    individual_tickets.where(owner: nil).count
  end

  private

  def set_default_status
    self.status ||= :active # デフォルトで「active」に設定
  end
  
    # Ransackで検索可能な属性を指定
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "description", "created_at", "updated_at"]
  end
  
  # Ransackで検索可能な関連付けを指定
  def self.ransackable_associations(auth_object = nil)
    ["issuer", "likes", "comments", "individual_tickets", "recipient"]
  end
end
