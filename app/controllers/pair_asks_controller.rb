class PairAsksController < ApplicationController
  before_action :set_ask, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all
    @asks = PairAsk.not_answered.
      with_filters(params[:location], params[:day], params[:time])
    if params[:location] || params[:day] || params[:time]
      render '_pair_asks', layout: false
    end
  end

  def show
  end

  def new
    @ask = PairAsk.new
    @locations = Location.all
    @meetups = MeetupTime.all
  end

  def create
    @ask = PairAsk.new(ask_params)
    if locations = params["pair_ask"]["locations"]
      locations.each { |location| @ask.locations << Location.find(location) }
    end
    if meetups = params["pair_ask"]["meetup_times"]
      meetups.each { |meetup| @ask.meetup_times << MeetupTime.find(meetup) }
    end

    if  valid_recaptcha? && @ask.save
      redirect_to thank_you_pair_request_path
    else
      @locations = Location.all
      @meetups = MeetupTime.all
      render action: 'new'
    end
  end

  private

    def set_ask
      @ask = Ask.find(params[:id])
    end

    def ask_params
      params.require(:pair_ask).permit(:name, :email, :description)
    end

    def valid_recaptcha?
      verify_recaptcha(model: @ask,
                       message: "Captcha verification failed, please try again")
    end
end
