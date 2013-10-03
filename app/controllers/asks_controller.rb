class AsksController < ApplicationController
  before_action :signed_in_admin
  before_action :set_ask, only: [:show, :destroy]

  def index
    @asks = Ask.all
    @locations = Location.all
    @categories = Category.all
  end

  def show
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
