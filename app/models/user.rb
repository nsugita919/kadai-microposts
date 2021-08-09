class User < ApplicationRecord
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 },
        format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
        uniqueness: { case_sensitive: false }
    has_secure_password
    
    has_many :favorites
    has_many :microposts
    
    # Userから直接「多対多」のUser達を取得できる
    # has_many :favoriteposts という関係を新しく命名し、『お気に入り登録したポスト群』
    # through: 中間テーブルの指定
    # source: 中間テーブルでどのカラムを参照先として使うか
    has_many :favoriteposts, through: :favorites, source: :micropost
    
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationship, source: :user
    
    def follow(other_user)
        unless self == other_user
          self.relationships.find_or_create_by(follow_id: other_user.id)
        end
    end
    
    def unfollow(other_user)
        relationship = self.relationships.find_by(follow_id: other_user.id)
        relationship.destroy if relationship
    end
    
    def following?(other_user)
        self.followings.include?(other_user)
    end
    
    def favorite(micropost)
        self.favorites.find_or_create_by(micropost_id: micropost)
    end
    
    def unfavorite(micropost)
        favorite = self.favorites.find_by(micropost_id: micropost)
        favorite.destroy if favorite
    end
    
    def favorited?(micropost)
        self.favoriteposts.include?(micropost)
    end
    
    def feed_microposts
        Micropost.where(user_id: self.following_ids + [self.id])
    end
    
end
