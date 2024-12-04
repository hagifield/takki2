class Public::RequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: [:update]

  # リクエスト作成（所有者が使用リクエストを送る）
  def create
    @individual_ticket = IndividualTicket.find(params[:individual_ticket_id])

    # 所有者以外がリクエストを送るのを防ぐ
    unless @individual_ticket.owner == current_user
      redirect_to individual_ticket_path(@individual_ticket), alert: "権限がありません。"
      return
    end

    # 新しいリクエストを作成
    @request = Request.new(
      individual_ticket: @individual_ticket,
      owner: current_user
    )

    if @request.save
      # 発行者を親チケットから取得
      issuer = @individual_ticket.ticket.issuer
        
      # 発行者に通知を送る
      create_notification_for_issuer(issuer, @request)
      redirect_to individual_ticket_path(@individual_ticket), notice: "使用リクエストを送信しました。"
    else
      redirect_to individual_ticket_path(@individual_ticket), alert: "使用リクエストの送信に失敗しました。"
    end
  end

  # リクエスト更新（発行者が承認または拒否）
  def update
    @request.status = params[:status]

    if @request.save
      # 承認された場合、個別チケットを使用済みにする
      case @request.status
      when 'approved'
        # 承認された場合、個別チケットを使用済みにする
        @request.individual_ticket.update!(status: :used)

        # 所有者に通知を送る
        create_notification_for_owner(@request.owner, @request, 'ticket_use_approved')
        redirect_to individual_ticket_path(@request.individual_ticket), notice: "リクエストを承認しました。"
      when 'rejected'
        # 拒否された場合、所有者に通知を送る
        create_notification_for_owner(@request.owner, @request, 'ticket_use_rejected')
        redirect_to individual_ticket_path(@request.individual_ticket), notice: "リクエストを拒否しました。"
      end
    else
      redirect_to individual_ticket_path(@request.individual_ticket), alert: "リクエストの更新に失敗しました。"
    end
  end

  private

  def set_request
    @request = Request.find(params[:id])
  end
  
  # 発行者に通知を送るメソッド
  def create_notification_for_issuer(issuer, request)
    issuer.notifications.create(
      notifiable: request,
      action_type: 'ticket_use_request',
      message: "#{request.owner.name} さんがチケット「#{request.individual_ticket.ticket.name}」の使用リクエストを送信しました。"
    )
  end

  # 所有者に通知を送るメソッド
  def create_notification_for_owner(owner, request, action_type)
    message = case action_type
              when 'ticket_use_approved'
                "チケット「#{request.individual_ticket.ticket.name}」の使用リクエストが承認されました。"
              when 'ticket_use_rejected'
                "チケット「#{request.individual_ticket.ticket.name}」の使用リクエストが拒否されました。"
              else
                "不明な通知です。"
              end

    owner.notifications.create(
      notifiable: request,
      action_type: action_type,
      message: message
    )
  end

end
