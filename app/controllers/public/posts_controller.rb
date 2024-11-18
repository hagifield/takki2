class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_tickets, only: [:new, :create]
  
  
  def new
    @post = Post.new(
      text_content: params[:saved_text_content], # 保存されたテキストを復元
      image: params[:saved_image] # 保存された画像情報を復元
    )
  end

  def create
    @post = current_user.posts.build(post_params) # 親モデル(current_user)に関連付けた投稿を作成

    if @post.save
      redirect_to @post, notice: '投稿が作成されました。'
    else
      render :new, alert: '投稿の作成に失敗しました。'
    end
  end

  def show
  end

  def index
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(30)
  end

  def edit
    redirect_to posts_path, alert: '編集権限がありません。' unless @post.user == current_user
  end


  def update
    
    # 削除する画像の処理
    if params[:remove_images].present?
      params[:remove_images].each do |signed_id|
        image = @post.images.find { |img| img.signed_id == signed_id }
        image.purge if image.present?
      end
    end
  
    # 投稿の更新
    if @post.user == current_user && @post.update(post_params)
      redirect_to post_path(@post), notice: '投稿が更新されました。'
    else
      @tickets = current_user.tickets.where(status: "unused")
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
    params.require(:post).permit(:text_content, :ticket_id, images: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end
  
  # 発行済みかつ未使用のチケットを取得
  def set_tickets
    @tickets = current_user.issued_tickets.unused
  end

  
end