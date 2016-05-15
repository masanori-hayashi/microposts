class LikesController < ApplicationController
  before_action :logged_in_user
  
 
  def create
    @micropost = Micropost.find(params[:id])
    @like = current_user.like(@micropost)
    @like.save
  end
  
  def destroy
    @micropost = current_user.likes.find(params[:id]).micropost
    current_user.unlike(@micropost)
  end
end
