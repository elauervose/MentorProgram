class AsksController < ApplicationController
  before_action :set_ask, only: [:show, :edit, :update, :destroy]

  def index
    @asks = Ask.all
    @locations = Location.all
    @categories = Category.all
  end

  def show
  end

  def edit
  end

  def update
    if @ask.update(ask_params)
      format.html { redirect_to @ask, notice: 'Ask was successfully updated.' }
    else
      render action: 'edit'
    end
  end

  def destroy
    @ask.destroy
    redirect_to asks_url
  end

  private

    def set_ask
      @ask = Ask.find(params[:id])
    end

    def ask_params
      params.require(:ask).permit(:name, :email, :description)
    end

end
