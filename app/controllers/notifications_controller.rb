class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.limit(10).page(params[:page])
    # 未確認の通知を確認済みにする
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  def destroy_all
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to users_notifications_path
  end

end
