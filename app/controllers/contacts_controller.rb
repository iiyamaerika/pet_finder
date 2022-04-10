class ContactsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :confirm, :back, :create, :done]

  def new
    @contact = Contact.new
  end

  # 確認画面
  def confirm
    @contact = Contact.new(contact_params)
    if @contact.invalid?
      flash.now[:alert] = 'お問合せの作成に失敗しました（＊は全て記入してください）'
      render :new
    end
  end

  # 入力内容に誤りがあった場合、入力内容を保持したまま前のページに戻る
  def back
    @contact = Contact.new(contact_params)
    render :new
  end

  # 実際に送信、ここで入力内容を保存
  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      redirect_to done_path
    else
      render :new
    end
  end

  # 送信完了画面
  def done
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :subject, :message)
  end
end
