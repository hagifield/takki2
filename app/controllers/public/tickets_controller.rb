class Public::TicketsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy] # ユーザー認証を必須にする
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :individual_tickets]
  before_action :ensure_issuer, only: [:edit, :update, :destroy]

  # 新規チケット作成フォーム
  def new
    @ticket = Ticket.new
    @followed_users = current_user.followings # ユーザーがフォローしている他のユーザーを取得
  end

  # チケットの作成処理
  def create
    @ticket = current_user.issued_tickets.build(ticket_params)
    

    if @ticket.save
      
      create_individual_tickets(@ticket)
      
      # 「誰かに渡す意思」がある場合は個別チケット一覧ページへリダイレクト
      if params[:ticket][:transfer] == "true" # チェックボックスがオンの場合
        redirect_to issued_individual_tickets_path(@ticket), notice: "チケットを作成しました。チケットを渡す人を選びましょう！。"
      else
        redirect_to tickets_path, notice: "チケットを作成しました。"
      end
    else
      @followed_users = current_user.followings # エラー時の再表示用
      flash.now[:alert] = "チケットの作成に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  # 発行したチケット一覧
  def index
    # 公開されているチケットを取得
    @tickets = Ticket.where(private: false).order(created_at: :desc)
    
    @q = Ticket.where(private: false).ransack(params[:q])
    
    if params[:q].present?
      @searched_ticket = @q.result(distinct: true).order(created_at: :desc)
      #distinct: trueでテーブル結合による重複を回避
    else
      @searched_ticket = []#検索していない時は空の情報を代入
    end
    
  end

  # チケットの詳細
  def show
    # @ticketはset_ticketメソッドで取得
    #チケットがプライベートの際の条件分岐（権限があればreturnで@ticketが有効になる）
    unless !@ticket.private? || @ticket.issuer == current_user || @ticket.individual_tickets.exists?(owner_id: current_user.id)
      redirect_to tickets_path, alert: "このチケットにアクセスする権限がありません"
      return
    end
    
    # 個別チケットを表示
    @individual_tickets = @ticket.individual_tickets
    @comments = @ticket.comments
  end

  # チケット編集画面
  def edit
    #@ticketはset_ticketで設定済み
  end

  # チケットの更新処理
  def update
    if @ticket.update(ticket_params)
      redirect_to ticket_path(@ticket), notice: "チケットが更新されました。"
    else
      flash.now[:alert] = "チケットの更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  # チケットの削除処理
  def destroy
    if @ticket.destroy
      flash[:notice] = "チケットを削除しました。"
      redirect_to tickets_path
    else
      flash[:alert] = "チケットの削除に失敗しました。"
      redirect_to ticket_path(@ticket)
    end
  end

  # 特定ユーザーの発行チケット一覧
  def issued_tickets
    @user = User.find(params[:user_id]) # 発行ユーザーを特定
    if @user != current_user
      @tickets = @user.issued_tickets.where(private: false).order(created_at: :desc)
    else
      @tickets = @user.issued_tickets.order(created_at: :desc)
    end
  end
  
  # 発行済個別チケット一覧
  def individual_tickets
    #@ticketはset_ticketで設定済
    unless @ticket.issuer == current_user
      redirect_to root_path, alert: "このページにアクセスする権限がありません。"
      return
    end

    @individual_tickets = @ticket.individual_tickets.includes(:owner, :requests)
  end


  private

  # 個別チケットを自動生成
  def create_individual_tickets(ticket)
    ticket.quantity.times do |i|
      ticket.individual_tickets.create!(
        serial_number: "TICKET-#{ticket.id}-#{i + 1}"
      )
    end
  end

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  # チケットの発行者であることを確認する
  def ensure_issuer
    unless @ticket.issuer_id == current_user.id
      flash[:alert] = "チケットを編集または削除する権限がありません。"
      redirect_to tickets_path
    end
  end

  def ticket_params
    params.require(:ticket).permit(:name, :description, :expiration_date, :quantity, :recipient_id, :private)
  end
end
