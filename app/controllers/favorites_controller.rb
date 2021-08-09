class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    # hidden 値を取得
    micropost = params[:micropost_id]

    current_user.favorite(micropost)
    flash[:success] = 'お気に入りに登録しました。'
    redirect_back fallback_location: root_url
  end

  def destroy
    # hidden 値を取得
    micropost = params[:micropost_id]

    current_user.unfavorite(micropost)
    flash[:success] = 'お気に入りから解除しました。'
    redirect_back fallback_location: root_url
  end
end
