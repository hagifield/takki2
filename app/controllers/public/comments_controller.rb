class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
        create_notification(@comment) 
        redirect_to polymorphic_path(@commentable), notice: "コメントしました"
    else
        redirect_back(fallback_location: root_path, alert: "コメントに失敗しました")
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable
    
    if @comment.destroy
      redirect_to polymorphic_path(@commentable), notice: "コメントを削除しました"
    else
      redirect_back(fallback_location: root_path, alert: "コメントの削除に失敗しました")
    end
  end
  
  private
  
  def comment_params
      params.require(:comment).permit(:content)
  end
  
  def find_commentable
    if params[:post_id]
        Post.find(params[:post_id])
    elsif params[:ticket_id]
        Ticket.find(params[:ticket_id])
    end
  end
  
  def create_notification(comment)
    
    commentable = comment.commentable
    
        if commentable.is_a?(Post)
            recipient = commentable.user
            title = commentable.text_content
        elsif commentable.is_a?(Ticket)
           recipient = commentable.issuer
           title = commentable.name
        else
            return
        end
        
        return if recipient == current_user
        
        recipient.notifications.create!(
            notifiable: commentable,
            action_type: 'comment',
            message: "#{current_user.name}さんがあなたの「#{title}」にコメントしました"
            )
        
        
  end
  
  
end
