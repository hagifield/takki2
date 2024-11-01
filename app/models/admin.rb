class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
         # 管理者通知モデルとの関連付け
  has_many :admin_notifications, as: :notifiable, dependent: :destroy
end
