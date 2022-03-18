module NotificationsHelper
  def notification_form(notification)
    #通知を送ってきたユーザーを取得
    @visitor = notification.visitor
    #コメントの内容を通知に表示する
    @comment = nil
    @visitor_comment = notification.post_comment_id
    # notification.actionがfavoriteかcommentかで処理を変える
    case notification.action
    when 'favorite'
      #aタグで通知を作成したユーザーshowのリンクを作成
      tag.a(notification.visitor.name, href: user_path(@visitor)) + 'が' + tag.a('あなたの投稿', href: article_path(notification.article_id)) + 'にいいねしました'
    when 'comment' then
      #コメントの内容と投稿のタイトルを取得
      @comment = PostComment.find_by(id: @visitor_comment)
      @comment_content =@comment.comment
      @article_title =@comment.article.title
      tag.a(@visitor.name, href: user_path(@visitor)) + 'が' + tag.a("#{@article_title}", href: article_path(notification.article_id)) + 'にコメントしました'
    when 'follow'
      tag.a(notification.visitor.name, href: user_path(@visitor)) + 'があなたをフォローしました'
    end
  end
  
  #通知がある時のマーク
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
