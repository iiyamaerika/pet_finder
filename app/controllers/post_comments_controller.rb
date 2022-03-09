class PostCommentsController < ApplicationController
  def create
    article = Article.find(params[:article_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.article_id = article.id
    comment.save
    redirect_to article_path(article)
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
