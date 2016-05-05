class UsersController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update,:following, :followers]
  before_action :collect_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end
  
  def followings
    @user  = User.find(params[:id])
    @users = @user.following_users
  end
  
  def followers
    @user  = User.find(params[:id])
    @users = @user.follower_users
  end

  
  private
  
  def set_user
    @user = User.find(params[:id])
  end    
  
  def collect_user
    # 自分　= current_user
    # 編集しようとしているユーザー　＝　@user
    redirect_to root_path if current_user != @user
  end
  
  
  def user_params
    params.require(:user).permit(:name, :email, :password,:address, :profile,
                                 :password_confirmation)
  end
end
