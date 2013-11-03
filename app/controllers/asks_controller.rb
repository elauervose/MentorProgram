class AsksController < ApplicationController
  before_action :signed_in_admin, except: :validate
  before_action :set_ask, only: [:show, :destroy]

  def index
    @asks = Ask.all.includes(:answer)
    @locations = Location.all
    @categories = Category.all
  end

  def show
  end

  def destroy
    @ask.destroy
    redirect_to asks_url
  end

  def validate
    token = params[:token]
    @ask = Ask.validate_request(token)
    render 'validate'
  end

  private

  def set_ask
    @ask = Ask.find(params[:id])
  end

  def ask_params
    params.require(:ask).permit(:name, :email, :description)
  end

  def allowed_to_delete
    redirect_to root_path unless params[:token] == @ask.token || signed_in_admin
  end

end
