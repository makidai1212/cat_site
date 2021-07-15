class Micropost < ApplicationRecord
  belongs_to       :user
  has_one_attached :image
  has_many :likes, dependent: :destroy
  has_many :iine_users, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message: "should be less than 5MB" }


  # 表示用のリサイズ済み画像を返す
  def display_image
    # variantは幅を統一するメソッド
    image.variant(resize_to_limit: [500, 500])
  end

  # マイクロポストをいいねする
  def iine(user)
    likes.create(user_id: user.id)
  end

  # マイクロポストのいいねを解除する
  def uniine(user)
    likes.find_by(user_id: user.id).destroy
  end

  def iine?(user)
    iine_users.include?(user)
  end

  # 投稿にお気に入りした際にNotificationテーブルにデータを作成する
  def create_notification_like(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and micropost_id = ? and action = ?", 
                                current_user.id, user_id, id, 'like'])
    if temp.blank?
      notification = current_user.active_notifications.build( micropost_id: id,
                                                              visited_id: user_id,
                                                              action: 'like'
                                                            )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
    notification.save if notification.valid?
    end
  end

  def create_notification_comment(current_user, comment_id)
    # Commentテーブルの中からuser_idが以下のやつを抽出する
    # コメントがついている投稿があって、かつ自分で自分にコメントしたものでないもの
    temp_ids = Comment.select(:user_id).where(micropost_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は投稿者に通知を送る？
    save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.build( micropost_id: id,
                                                            visited_id: visited_id,
                                                            action: 'comment'
                                                          )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end