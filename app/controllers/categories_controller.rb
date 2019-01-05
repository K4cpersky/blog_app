class CategoriesController < ApplicationController

  before_action :require_admin, except: [:index, :show]

  def index
    @categories = Category.paginate(page: params[:page], per_page: 5)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(categories_params)
    if @category.save
      flash[:notice] = "Category was succesfully created"
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def show
    @category = Category.find(params[:id])
    @category_articles = @category.articles.paginate(page:params[:page], per_page: 5)
  end

  private
  def categories_params
    params.require(:category).permit(:name)
  end
  def require_admin
    if !logged_in? || (logged_in? && !current_user.admin?)
      flash[:notice] = 'Only admin users can perform that action'
      redirect_to categories_path
    end
  end
end
