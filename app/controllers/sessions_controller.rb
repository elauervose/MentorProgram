class SessionsController < ApplicationController
  
  def new
  end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin
      # go to admin homepage
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end

end
