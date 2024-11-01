class Post < ApplicationRecord
  
  #バリデーション
  with_options presence: true do
    validates :text_content 
  end
    
  # ユーザーモデルとの関連付け: 投稿はユーザーに属する
  belongs_to :user

  # チケットモデルとの関連付け: 投稿は複数のチケットを持つことができる
  has_many :tickets, dependent: :destroy

  # コメントモデルとの関連付け: 投稿に対するコメント
  has_many :comments, as: :commentable, dependent: :destroy

  # いいね機能の設定
  has_many :likes, as: :likable, dependent: :destroy

  # Active Storage設定: 投稿に含まれる画像
  # has_manyで複数枚画像投稿できる
  has_many_attached :images
end
