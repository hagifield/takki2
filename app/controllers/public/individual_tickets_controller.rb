class Public::IndividualTicketsController < ApplicationController
  before_action :set_individual_ticket, only: [:show, :update, :mark_as_used, :transfer]

  def index
    @individual_tickets = IndividualTicket.includes(:ticket)
  end

  def show
    #メソッド内で@individual_ticketを設定済み
    
    # 所有者または発行者であることを確認
    unless @individual_ticket.owner == current_user || @individual_ticket.ticket.issuer == current_user
      redirect_to individual_tickets_path, alert: "このチケットにアクセスする権限がありません。"
    end
    @ticket = @individual_ticket.ticket
  end

  def update
    if @individual_ticket.update(individual_ticket_params)
      redirect_to individual_ticket_path(@individual_ticket), notice: "チケット情報を更新しました。"
    else
      flash.now[:alert] = "チケット情報の更新に失敗しました。"
      render :show, status: :unprocessable_entity
    end
  end
  
   # チケットを取得する
  def acquire
    ticket = Ticket.find(params[:ticket_id]) # 親チケットを取得

    # 未割り当ての個別チケットを取得
    individual_ticket = ticket.individual_tickets.find_by(owner: nil)

    if individual_ticket
      individual_ticket.update!(owner: current_user) # 所有者を現在のユーザーに設定
      redirect_to individual_ticket_path(individual_ticket), notice: "チケットを取得しました！"
    else
      redirect_to ticket_path(ticket), alert: "このチケットはすでに取得されてしまいました。"
    end
  end

  def mark_as_used
    if @individual_ticket.unused?
      @individual_ticket.update!(status: :used)
      redirect_to individual_ticket_path(@individual_ticket), notice: "チケットを使用済みにしました。"
    else
      redirect_to individual_ticket_path(@individual_ticket), alert: "チケットはすでに使用済みまたは期限切れです。"
    end
  end

  def transfer
    new_owner = User.find(params[:new_owner_id])
    if @individual_ticket.update(owner: new_owner)
      redirect_to individual_ticket_path(@individual_ticket), notice: "チケットを譲渡しました。"
    else
      redirect_to individual_ticket_path(@individual_ticket), alert: "チケットの譲渡に失敗しました。"
    end
  end

  private

  def set_individual_ticket
    @individual_ticket = IndividualTicket.find(params[:id])
  end

  def individual_ticket_params
    params.require(:individual_ticket).permit(:status, :owner_id)
  end
end
