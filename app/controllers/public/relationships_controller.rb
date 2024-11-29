class Public::RelationshipsController < ApplicationController

  # フォローする
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    # 通知を作成
    create_notification(@user)

    redirect_to request.referer || users_path, notice: "#{@user.name} をフォローしました"
  end

  # フォローを解除する
  def destroy
    @user = User.find(params[:id])
    current_user.unfollow(@user)
    redirect_to request.referer || users_path, notice: "#{@user.name} のフォローを解除しました"
  end

  private
  
  # 通知を作成するメソッド
  def create_notification(followed_user)
    followed_user.notifications.create(
      notifiable: current_user, # フォローしてきたユーザー
      action_type: 'follow',
      message: "#{current_user.name} さんがあなたをフォローしました"
    )
  end

end
