class Public::TicketsController < ApplicationController
  before_action :authenticate_user! # ユーザー認証を必須にする

  # 新規チケット作成フォーム
  def new
    @ticket = Ticket.new
    @followed_users = current_user.followings # ユーザーがフォローしている他のユーザーを取得
  end

  # チケットの作成処理
  def create
    @ticket = current_user.issued_tickets.build(ticket_params)
    # 渡すユーザーが指定されている場合はプライベートチケットに設定
    @ticket.private = params[:ticket][:recipient_id].present?

    if @ticket.save
      redirect_to tickets_path, notice: "チケットを作成しました"
    else
      @followed_users = current_user.followings # エラー時の再表示用
      render :new, status: :unprocessable_entity
    end
  end

  # 発行したチケット一覧
  def index
    @tickets = current_user.issued_tickets.order(created_at: :desc)
  end
  
  def show
    @ticket = Ticket.find(params[:id])
  end

  # チケットを特定のユーザーに直接渡す
  def transfer
    @ticket = current_user.issued_tickets.find(params[:id]) # 自分の発行したチケットのみ対象
    recipient = User.find_by(id: params[:recipient_id])

    if recipient
      @ticket.update(recipient: recipient, private: true) # 受取人を設定してプライベートに変更
      redirect_to tickets_path, notice: "チケットを#{recipient.name}に渡しました"
    else
      redirect_to tickets_path, alert: "受取人が見つかりませんでした"
    end
  end

  private

  # Strong Parameters
  def ticket_params
    params.require(:ticket).permit(:name, :description, :expiration_date, :quantity, :recipient_id)
  end
end
