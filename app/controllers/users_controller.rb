class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
#  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.limit(15).page(params[:page])
  end

  # アカウント有効化機能解除のため一部コメントアウトして修正。6/23
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "登録に成功しました！"
      # @user.send_activation_email
      # flash[:info] = "メール送信しました。メールからアカウント有効化してください"
      # redirect_to root_url
      
      # アカウント有効化機能を復活させる時はこちらをコメントアウトすること
      log_in @user
      redirect_to @user
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
    @users = User.limit(15).page(params[:page])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    if current_user.admin?
    flash[:success] = "#{@user.name} さんを削除しました！"
    redirect_to users_path
    else
      flash[:success] = "アカウントを削除しました。またのご利用をお待ちしております。にゃん"
      redirect_to root_path
    end
  end

  def following
    @title = "フォローしている人"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def likes
    @likes = Like.where(user_id: current_user).limit(15).page(params[:page])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
