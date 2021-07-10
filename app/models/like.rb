class Like < ApplicationRecord
  default_scope -> { order( created_at: :desc) }
  belongs_to :user
  belongs_to :micropost
  counter_culture :micropost
  validates :user_id, presence: true
  validates :micropost_id, presence: true
end
