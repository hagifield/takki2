class Notification < ApplicationRecord
    
  # ポリモーフィック関連付け（いいね、コメント、チケット、フォロー関連）
  belongs_to :notifiable, polymorphic: true

  # 通知を受け取るユーザーとの関連付け
  belongs_to :user

  # 既読・未読の判定
  scope :unread, -> { where(read_at: nil) }

  # メソッド例: 既読にする
  def mark_as_read
    update(read_at: Time.current)
  end
end
