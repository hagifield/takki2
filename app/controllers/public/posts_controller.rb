class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    if @post.save
      redirect_to post_path(@post), notice: '投稿が作成されました。'
    else
      flash.now[:alert] = '投稿の作成に失敗しました。'
      render :new
    end
  end

  def show
  end

  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def edit
    redirect_to posts_path, alert: '編集権限がありません。' unless @post.user == current_user
  end

  def update
    if @post.user == current_user && @post.update(post_params)
      redirect_to @post, notice: '投稿が更新されました。'
    else
      flash.now[:alert] = '投稿の更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    if @post.user == current_user
      @post.destroy
      redirect_to posts_path, notice: '投稿が削除されました。'
    else
      redirect_to posts_path, alert: '削除権限がありません。'
    end
  end
  
  private

  def post_params
    params.require(:post).permit(:text_content, :image, :ticket_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end
  
end