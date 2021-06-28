class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end

    # 全部表示させるための設定
    @article = Micropost.order(created_at: :desc).limit(15).page(params[:page])
    @paginatable_array = Kaminari.paginate_array([], total_count: 150).page(params[:page])
  end

  def about
  end

  def contact
  end
end
