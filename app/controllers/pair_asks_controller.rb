class PairAsksController < ApplicationController
  before_action :set_ask, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all
    @asks = PairAsk.not_answered.
      with_filters(params[:location], params[:day], params[:time])
    if filters_selected?
      render '_pair_asks', layout: false
    end
  end

  def show
  end

  def edit
    set_assosciation_locals
  end

  def update
    if @ask.update(ask_params)
      format.html { redirect_to @ask, notice: 'Ask was successfully updated.' }
    else
      render action: 'edit'
    end
  end

  def new
    @ask = PairAsk.new
    set_assosciation_locals
  end

  def create
    @ask = PairAsk.new(ask_params)
    add_locations(params["pair_ask"]["locations"])
    add_meetup_times(params["pair_ask"]["meetup_times"])

    if  valid_recaptcha? && @ask.save
      redirect_to thank_you_pair_request_path
    else
      set_assosciation_locals
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

    def set_assosciation_locals
      @locations = Location.all
      @meetups = MeetupTime.all
    end

    def filters_selected?
      params[:location] || params[:day] || params[:time]
    end

    def add_locations(locations)
      if locations
        locations.each { |location| @ask.locations << Location.find(location) }
      end
    end

    def add_meetup_times(meetups)
      if meetups
        meetups.each { |meetup| @ask.meetup_times << MeetupTime.find(meetup) }
      end
    end
end
