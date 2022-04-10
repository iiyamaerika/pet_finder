class PostCommentsController < ApplicationController
  before_action :authenticate_user! # ログインユーザーのみコメント可能

  def create
    @article = Article.find(params[:article_id])
    @post_comment = current_user.post_comments.new(post_comment_params)
    @post_comment.article_id = @article.id
    if @post_comment.save
      flash[:notice] = 'コメントしました'
      @article.create_notification_comment!(current_user, @post_comment.id)
      redirect_to article_path(@article)
    else
      flash.now[:alert] = 'コメントを入力してください'
      render 'articles/show'
    end
  end

  def destroy
    PostComment.includes([:user]).find(params[:id]).destroy
    flash[:notice] = 'コメントを削除しました'
    redirect_to article_path(params[:article_id])
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
