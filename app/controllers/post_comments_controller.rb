class PostCommentsController < ApplicationController
  before_action :authenticate_user! #ログインユーザーのみコメント可能
  
  def create
    article = Article.find(params[:article_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.article_id = article.id
    if @comment.save
      flash[:success] = 'コメントしました'
      @article = @comment.article
      @article.create_notification_comment!(current_user, @comment.id)
      redirect_to article_path(article)
    else
      comments_get
      render 'articles/show'
    end
  end

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_to article_path(params[:article_id])
  end
  
  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
  
end
