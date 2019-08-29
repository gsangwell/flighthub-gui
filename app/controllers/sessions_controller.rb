class SessionsController < ApplicationController
  include Clearance::Controller

  def create
    if User.authenticate(params[:session][:username], params[:session][:password])
      user = User.find_or_create_by!(username: params[:session][:username])
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
