require 'test_helper'

class LikesCountTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other = users(:archer)
    @micropost = microposts(:orange)
    log_in_as(@user)
  end

  test "お気に入りが機能する" do
    assert_difference '@micropost.likes.count',1 do
      post likes_path, params: { user_id: @other.id, micropost_id: @micropost.id}
    end
  end

end
