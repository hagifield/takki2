class Public::LikesController < ApplicationController
  before_action :set_likable
  
  def index_posts
    @user = User.find(params[:id])
    # ポリモーフィック関連付けより、ユーザーがいいねした投稿のみ取得
    @likes = @user.likes.where(likable_type: 'Post').includes(:likable)
  end
  
  def index_tickets
    @user = User.find(params[:id])
    # ポリモーフィック関連付けより、ユーザーがいいねしたチケットのみ取得
    @likes = @user.likes.where(likable_type: 'Ticket').includes(:likable)
  end

  def create
    @like = @likable.likes.new(user: current_user)
    if @like.save
      redirect_back(fallback_location: root_path, notice: 'いいねしました！')
    else
      redirect_back(fallback_location: root_path, alert: 'いいねに失敗しました。')
    end
  end

  def destroy
    @like = @likable.likes.find_by(user: current_user)
    if @like&.destroy
      redirect_back(fallback_location: root_path, notice: 'いいねを解除しました。')
    else
      redirect_back(fallback_location: root_path, alert: 'いいね解除に失敗しました。')
    end
  end

  private

  def set_likable
    resource, id = request.path.split('/')[1, 2]
    @likable = resource.singularize.classify.constantize.find(id)
  end
end
