class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :show, :destroy, :followers, :followings]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def mypage
    @user = current_user
    @posts = @user.posts.order(created_at: :desc) # 投稿を新しい順に並び替え
  end

  def edit
    # 編集ページ表示。@userはbefore_actionのset_userで設定済み
  end

  def update
    if @user.update(user_params)
      redirect_to mypage_path, notice: 'プロフィールが更新されました。'
    else
      render :edit
    end
  end

  def show
    # 他のユーザーのプロフィールを表示。@userはbefore_actionのset_userで設定済み
    @posts = @user.posts.order(created_at: :desc) # 投稿を新しい順に並び替え
  end

  def index
    @users = User.page(params[:page]).per(30)
  end
  
  # Userモデル内のfollowメソッドを呼び出して指定のユーザーをフォロー
  def follow
    current_user.follow(@user)
    redirect_to user_path(@user), notice: "#{@user.name}さんをフォローしました"
  end
  # Userモデル内のunfollowメソッドを呼び出してフォロー解除
  def unfollow
    current_user.unfollow(@user)
    redirect_to user_path(@user), notice: "#{@user.name}さんのフォローを解除しました"
  end
  #　フォローしているユーザー一覧
  def followings
    @users = @user.followings
    @followings = @user.followings
  end
  #　フォロワー一覧
  def followers
    @users = @user.followers
    @followers = @user.followers
  end

  def destroy
    @user.destroy
    redirect_to root_path, notice: 'ユーザーが削除されました。'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :introduction)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    unless @user == current_user
      redirect_to mypage_path, alert: '権限がありません。無効なアクセスです。'
    end
  end
end
