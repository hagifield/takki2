class IndividualTicket < ApplicationRecord
  # 親チケット（イベントチケット）との関連付け
  belongs_to :ticket

  # 所有者（ユーザー）との関連付け
  belongs_to :owner, class_name: "User", optional: true

  # 個別チケットの状態をenumで管理
  enum status: { unused: 0, used: 1, expired: 2 }

  # バリデーション
  validates :serial_number, presence: true, uniqueness: { scope: :ticket_id } # 同じ親チケット内で一意

  # メソッド: 状態を変更する便利メソッド
  def mark_as_used
    update!(status: :used)
  end

  def mark_as_expired
    update!(status: :expired)
  end
end
