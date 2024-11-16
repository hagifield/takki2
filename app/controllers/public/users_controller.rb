class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :show, :destroy, :followers, :followings]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def mypage
    @user = current_user
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
  end

  def index
    @users = User.page(params[:page]).per(30)
  end
  
  #フォロワー一覧
  def followers
    @followers = @user.followers
  end
  
  #フォロー一覧
  def followings
    @followings_users = @user.followings
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
      redirect_to mypage_path, alert: '権限がありません。'
    end
  end
end
