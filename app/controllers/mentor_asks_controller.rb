class MentorAsksController < ApplicationController
  include Locatable
  include Meetupable
  include Recaptchable
  before_action :signed_in_admin, only: [:edit, :update]
  before_action :set_ask, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all
    @categories = Category.admin_created
    @asks = MentorAsk.not_answered.with_filters(params[:location],
                                                params[:category],
                                                params[:day],
                                                params[:time]
                                               )
    if filters_selected?
      render '_mentor_asks', layout: false
    end
  end

  def show
  end

  def edit
    @ask.categories.build
    set_assosciation_locals
  end

  def update
    update_assosciations
    if @ask.update(ask_params)
      redirect_to @ask, notice: 'MentorAsk was successfully updated.'
    else
      set_assosciation_locals
      render action: 'edit'
    end
  end

  def new
    @ask = MentorAsk.new
    @ask.categories.build
    set_assosciation_locals
  end

  def create
    @ask = MentorAsk.new(ask_params)
    add_assosciations
    if  valid_recaptcha? && @ask.save
      redirect_to thank_you_mentee_path
    else
      set_assosciation_locals
      render action: 'new'
    end
  end

  private

  def set_ask
    @ask = MentorAsk.find(params[:id])
  end

  def ask_params
    params.require(:mentor_ask).permit(:name, :email, :description,
                                       categories_attributes: [:name])
  end

  def set_assosciation_locals
    @locations = Location.all
    @meetups = MeetupTime.all
    @categories = Category.admin_created
  end

  def filters_selected?
    params[:location] || params[:category] || params[:day] || params[:time]
  end

  def add_categories(categories)
    if categories
      categories.each { |category| @ask.categories << Category.find(category) }
    end
  end

  def add_assosciations
    add_locations(params["mentor_ask"]["locations"])
    add_meetup_times(params["mentor_ask"]["meetup_times"])
    add_categories(params["mentor_ask"]["categories"])
  end

  def update_assosciations
    update_locations(params["mentor_ask"]["locations"])
    update_meetup_times(params["mentor_ask"]["meetup_times"])
    update_categories(params["mentor_ask"]["categories"])
  end

  def update_categories(categories)
    if categories
      category_ids = categories.collect { |category| category.to_i }
      @ask.categories = Category.find(category_ids)
    else
      @ask.categorys.clear
    end
  end

end
