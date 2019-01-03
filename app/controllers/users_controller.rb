# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[update edit show]
  before_action :require_same_user, only: %i[edit update destroy]
  before_action :require_admin, only: [:destroy]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to the MEKARSKI BLOG #{@user.username}"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 3)
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 3)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'User and all his articles have been deleted'
    redirect_to users_path
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = 'User is successfully updated'
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:notice] = 'You can only edit your own account'
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? && !current_user.admin?
      flash[:notice] = 'Only admin users can perform that action'
      redirect_to root_path
    end
  end
end
