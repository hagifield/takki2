class Public::RelationshipsController < ApplicationController

  # フォローする
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    # 通知を作成するロジックは後で追加
    redirect_to request.referer || users_path, notice: "#{@user.name} をフォローしました"
  end

  # フォローを解除する
  def destroy
    @user = User.find(params[:id])
    current_user.unfollow(@user)
    redirect_to request.referer || users_path, notice: "#{@user.name} のフォローを解除しました"
  end

  private

end
