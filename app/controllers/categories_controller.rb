class CategoriesController < ApplicationController
  before_action :signed_in_admin
  before_action :prepare_category, only: [:edit, :update, :show, :destroy]

  def index
    @categories = Category.all
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @category.update_attributes(category_params)
      redirect_to category_path(@category)
    else
      render action: 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path
  end

  private
  
    def signed_in_admin
      redirect_to root_path unless signed_in?
    end

    def prepare_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :official)
    end

end
