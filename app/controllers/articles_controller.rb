# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :find_params, only: %i[edit show destroy update]
  before_action :require_user, except: %i[index show]
  before_action :require_same_user, only: %i[edit update destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def create
    # render plain: params[:article].inspect
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      flash[:notice] = 'Article was successfully created'
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def show; end

  def edit; end

  def update
    if @article.update(article_params)
      flash[:notice] = 'Article was successfully updated'
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    flash[:notice] = 'Article was successfully deleted.'
    redirect_to articles_path
  end

  private

  def require_same_user
    if current_user != @article.user && !current_user.admin?
      flash[:notice] = 'You can only edit or delete your own articles'
      redirect_to root_path
    end
  end

  def find_params
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end
end
