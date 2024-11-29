class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  # 通知一覧
  def index
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page])
  end

  # 通知を既読にする
  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read
    redirect_to polymorphic_path(@notification.notifiable)
  end

  # 通知を削除
  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy
    redirect_to notifications_path, notice: "通知を削除しました。"
  end
end
