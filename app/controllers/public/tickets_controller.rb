class Public::TicketsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy] # ユーザー認証を必須にする
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]
  before_action :ensure_issuer, only: [:destroy]


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
    # 公開されているチケットを取得
    @tickets = Ticket.where(private: false).order(created_at: :desc)
  end
  
  def show
    #@ticketはset_ticketで設定
  end
  
  def edit
    #@ticketはset_ticketで設定
  end

  def update
    if @ticket.update(ticket_params)
      redirect_to ticket_path(@ticket), notice: "チケットが更新されました。"
    else
      flash.now[:alert] = "チケットの更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
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
  
  def destroy
    if @ticket.destroy
      flash[:notice] = "チケットを削除しました。"
      redirect_to tickets_path
    else
      flash[:alert] = "チケットの削除に失敗しました。"
      redirect_to ticket_path(@ticket)
    end
  end




  private
  
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  # チケットの発行者であることを確認する
  def ensure_issuer
    unless @ticket.issuer_id == current_user.id
      flash[:alert] = "チケットを削除する権限がありません。"
      redirect_to tickets_path
    end
  end
  
  
  def ticket_params
    params.require(:ticket).permit(:name, :description, :expiration_date, :quantity, :recipient_id, :private)
  end
end
