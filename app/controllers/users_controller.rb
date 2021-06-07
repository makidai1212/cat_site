class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "メール送信しました。メールからアカウント有効化してください"
      redirect_to root_url
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "プロフィール更新成功！"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました！"
    redirect_to users_path
  end

  private
   
   def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end

   def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
   end

   def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
   end

   def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
