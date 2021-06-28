class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "投稿しました！"
      redirect_to root_path
    else
      # 全体表示に変更したためコメントアウト
      @feed_items = current_user.feed.paginate(page: params[:page])
      # ここの3行は全体表示に変更したため追加
      @article = Micropost.order(created_at: :desc).limit(15).page(params[:page])
      @paginatable_array = Kaminari.paginate_array([], total_count: 150).page(params[:page])
      @all_ranks = Micropost.find(Like.group(:micropost_id).order('count(micropost_id) desc').limit(5).pluck(:micropost_id))
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました"
    redirect_to request.referrer || root_path
  end

  def show
    @micropost = Micropost.find(params[:id])
    @comments = Comment.where(micropost_id: @micropost.id).order(created_at: :desc)
    @comment = @micropost.comments.build
    @micropost_comment = Comment.new
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_path if @micropost.nil?
  end
end
