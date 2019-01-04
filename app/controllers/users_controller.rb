class UsersController < ApplicationController
  def index
  end

  def create
    user = User.find_by(username: user_params[:username])
    unless user
      if user_params[:password] == user_params[:password_confirmation]
        new_user = User.new(
          username: user_params[:username],
          password: user_params[:password]
        )

        if new_user.save
          flash[:success] = 'User created successfully'
          redirect_to users_path
        else
          flash[:danger] = 'Encountered an error whilst saving the new user'
          redirect_to users_path
        end
      else
        flash[:danger] = 'The passwords do not match'
        redirect_to users_path
      end
    else
      flash[:danger] = 'That username is already in use'
      redirect_to users_path
    end
  end

  def modify
  end

  def remove
  end

  private

  def user_params
    params[:user]
  end
end
