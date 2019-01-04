class UsersController < ApplicationController
  def index
  end

  def new
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
          flash.now[:success] = 'User created successfully'
          render 'index'
        else
          flash.now[:danger] = 'Encountered an error whilst saving the new user'
          render 'new'
        end
      else
        flash.now[:danger] = 'The passwords do not match'
        render 'new'
      end
    else
      flash.now[:danger] = 'That username is already in use'
      render 'new'
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
