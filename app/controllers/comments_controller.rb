class CommentsController < ApplicationController

  def create
    micropost = Micropost.find(params[:micropost_id])
    @comment = micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = "コメントしました！"
      redirect_to micropost_path(micropost)
     else
      redirect_to micropost_path(micropost)
      flash[:danger] = "コメントを入力してください"
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    flash[:success] = "コメントを削除しました"
    redirect_to request.referrer
  end

  private

   def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id, micropost_id: params[:micropost_id])
   end
end
