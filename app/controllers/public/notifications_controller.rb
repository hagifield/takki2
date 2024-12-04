class Public::NotificationsController < ApplicationController
  before_action :authenticate_user!

  # 通知一覧
  def index
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page]).per(10)
  end

  # 通知を既読にする
  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read
    
    # Requestオブジェクトの場合、専用のパスにリダイレクト　→ ビュー内で分岐させた
    # if @notification.notifiable.is_a?(Request)
    #   redirect_to issued_individual_tickets_path(@notification.notifiable.individual_ticket.ticket_id)
    # end
  end

  # 通知を削除
  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy
    redirect_to notifications_path, notice: "通知を削除しました。"
  end
end
