class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit,:update]
  before_action :valid_user, only: [:edit,:update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード変更画面にアクセスするためのメールを送信しました！"
      redirect_to root_url
    else
      flash.now[:danger] = "登録のメールアドレスが見つかりません！"
      render 'new'
    end
  end

  def edit
    
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
     log_in @user
     flash[:success] = "パスワード変更に成功しました！"
     redirect_to @user
    else
     render 'edit'
    end
  end

  private

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      unless( @user && @user.activated? && @user.authenticated?( :reset, params[:id]))
        redirect_to root_path
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "パスワード更新の有効期限が切れています！"
        redirect_to new_password_reset_url
      end
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
