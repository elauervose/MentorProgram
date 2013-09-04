class AsksController < ApplicationController
  before_action :set_ask, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all
    @categories = Category.admin_created
    @asks = Ask.not_answered.with_filters(params[:location], params[:category],
                                         params[:day], params[:time])
    if params[:location] || params[:category] || params[:day] || params[:time]
      render '_asks', layout: false
    end
  end

  def show
  end

  def new
    @ask = Ask.new
    @ask.categories.build
    @locations = Location.all
    @meetups = MeetupTime.all
    @categories = Category.admin_created
  end

  def edit
  end

  def create
    @ask = Ask.new(ask_params)
    if locations = params["ask"]["locations"]
      locations.each { |location| @ask.locations << Location.find(location) }
    end
    if meetups = params["ask"]["meetup_times"]
      meetups.each { |meetup| @ask.meetup_times << MeetupTime.find(meetup) }
    end
    if categories = params["ask"]["categories"]
      categories.each { |category| @ask.categories << Category.find(category) }
    end

    if  valid_recaptcha? && @ask.save
      redirect_to thank_you_mentee_path
    else
      @locations = Location.all
      @meetups = MeetupTime.all
      @categories = Category.admin_created
      render action: 'new'
    end
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
      params.require(:ask).permit(:name, :email, :description,
                                 categories_attributes: [:name])
    end

    def valid_recaptcha?
      verify_recaptcha(model: @ask,
                       message: "Captcha verification failed, please try again")
    end
end
