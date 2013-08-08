class StaticController < ApplicationController
  def index
  end

  def about
  end

  def mentors
  end

  def mentees
  end

  def prep
  end

  def resources
  end

  def thank_you_mentor
    render :thank_you_mentor
  end

  def thank_you_mentee
    render :thank_you_mentee
  end  
end
