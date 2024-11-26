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
      # 発行者に通知を送る（将来的に通知モデルを使用）
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
      if @request.approved?
        @request.individual_ticket.update!(status: :used)

        # 所有者に通知を送る（将来的に通知モデルを使用）
      end

      redirect_to individual_ticket_path(@request.individual_ticket), notice: "リクエストを更新しました。"
    else
      redirect_to individual_ticket_path(@request.individual_ticket), alert: "リクエストの更新に失敗しました。"
    end
  end

  private

  def set_request
    @request = Request.find(params[:id])
  end

end
