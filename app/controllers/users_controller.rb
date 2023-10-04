class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @following_users = @user.following_users
    @follower_users  = @user.follower_users
    @books = @user.books.page(params[:page])
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
   if @user.update(user_params)
     flash[:notice] = "You have updated user successfully."
     redirect_to user_path
   else
     render :edit
   end
  end

  def index
    @users = User.all
    @book = Book.new
    @user = current_user
  end
  
  def follows
    user   = User.find(params[:user_id])
    @users = user.following_users
  end
  
  def followers
    user  = User.find(params[:user_id])
    @user = user.follower_users
  end

  private

  def user_params
    params.require(:user).permit(:name, :image, :introduction)
  end

  def correct_user
     @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user.id)
    end
  end
  
end