class SessionsController < ApplicationController
  include Clearance::Controller

  def create
    user = User.find_by(username: params[:session][:username])
    if User.authenticate(params[:session][:username], params[:session][:password])
      sign_in(user)
      redirect_back(fallback_location: cluster_path)
    else
      flash[:danger] = 'Invalid username or password'
      redirect_back(fallback_location: login_path)
    end
  end

  def destroy
    sign_out
    redirect_to login_path
  end
end
