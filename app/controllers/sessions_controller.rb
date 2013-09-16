class SessionsController < ApplicationController

  def new
  end

  def create
    admin = Admin.find_by(email: params[:email])
    if admin && admin.authenticate(params[:password])
      sign_in admin
      redirect_to admin_home_path 
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to admin_sign_in_path
  end

end
