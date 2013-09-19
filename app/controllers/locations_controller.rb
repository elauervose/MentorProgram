class LocationsController < ApplicationController
  before_action :signed_in_admin
  before_action :prepare_location, only: [:edit, :destroy]

  def index
    @locations = Location.all
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to locations_path
    else
      render action: 'new'
    end
  end

  def edit
  end

  def destroy
    @location.destroy
    redirect_to locations_path
  end

  private
  
    def signed_in_admin
      redirect_to root_path unless signed_in?
    end

    def prepare_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:name)
    end

end
