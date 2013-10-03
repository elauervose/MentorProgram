class StaticController < ApplicationController
  before_action :is_admin?, only: [:statistics, :admin_home]

  def index
  end

  def about
  end

  def table_test
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

  def admin_home
  end

  def statistics
  end

end
