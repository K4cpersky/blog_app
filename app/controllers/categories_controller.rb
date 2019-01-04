class CategoriesController < ApplicationController

  def index
    @categories = Category.all
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
  end

  private
  def categories_params
    params.require(:category).permit(:name)
  end
end
