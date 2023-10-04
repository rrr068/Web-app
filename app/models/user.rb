class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
         validates :name, uniqueness: true, length: { in: 2..20 }
         validates :introduction, length: { maximum: 50 }
         has_many :favorites, dependent: :destroy
         has_many :books, dependent: :destroy
         has_many :book_comments, dependent: :destroy
         
         has_one_attached :profile_image
         
         has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
         has_many :followeds, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
         
         has_many :following_users, through: :followers, source: :followed
         has_many :follower_users,  through: :followeds, source: :follower
         
         
  def get_profile_image(width, height)
  unless profile_image.attached?
    file_path = Rails.root.join('app/assets/images/no_image.jpeg')
    profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
  end
  profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  # フォローした時の処理
  def follow(user_id)
    followers.create(followed_id: user_id)
  end
  
  # フォローを返す時の処理
  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end
  
  # フォロー済みtrueを返す
  def following?(user)
    following_users.include?(user)
  end
  
  def self.looks(search, word)
    if search == "pefect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}")
    else
      @user = User.all
    end
  end
  
end
