class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      
      # 全部表示させるための設定
      @article = Micropost.order(created_at: :desc).limit(15).page(params[:page])
      @paginatable_array = Kaminari.paginate_array([], total_count: 150).page(params[:page])
      # ランキング表示のための設定
      @all_ranks = Micropost.find(Like.group by(:micropost_id).order('count(micropost_id) desc').limit(5).pluck(:micropost_id))
      
      ＠randams = Micropost.order("RAND()").limit(3)
    end

  end

  def about
  end

  def contact
  end
end
