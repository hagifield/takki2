class Ownership < ApplicationRecord
    
  # ユーザーモデルとの関連付け: 所有権はユーザーに属する
  belongs_to :user
  # チケットモデルとの関連付け: 所有権はチケットに属する
  belongs_to :ticket
end
