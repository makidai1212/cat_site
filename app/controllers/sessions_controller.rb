class SessionsController < ApplicationController
  def new
  end

  # sessionでダメならcookiesから探す
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
      log_in(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
      else
        message = "アカウントが有効化されていません！"
        +message = "アカウント有効化メールを確認してください！"
        flash[:warning] = message
        redirect_to root_path
      end
    else
      flash.now[:danger] = "emailかパスワードが正しくありません"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
