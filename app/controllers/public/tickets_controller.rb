class Public::TicketsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = current_user.issued_tickets.build(ticket_params)

    if @ticket.save
      redirect_to ticket_path(@ticket, redirect_to: "new_post", saved_text_content: params[:saved_text_content], saved_image: params[:saved_image])
    else
      flash.now[:alert] = 'チケットの作成に失敗しました。'
      render :new
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(:name, :description, :expiration_date, :quantity)
  end
  
end
