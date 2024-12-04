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
  
  def self.generate_message(action_type, notifiable)
    case action_type
    when 'follow'
      "#{notifiable.name}さんがあなたをフォローしました"
    when 'like'
      "#{notifiable.user.name}さんが「#{notifiable.title}」にいいねしました"
    when 'comment'
      "#{notifiable.user.name}さんが「#{notifiable.title}」にコメントしました"
    when 'ticket_transfer'
      "#{notifiable.title}のチケットが転送されました"
    else
      "新しい通知があります"
    end
  end
end
