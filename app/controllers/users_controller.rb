class UsersController < ApplicationController
  def index
    @users = User.all
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
        else
          flash[:danger] = 'Encountered an error whilst saving the new user'
        end
      else
        flash[:danger] = 'The passwords do not match'
      end
    else
      flash[:danger] = 'That username is already in use'
    end

    redirect_to users_path
  end

  def modify
    user = User.find(modify_params[:id])
    user.username = modify_params[:username]
    user.email = modify_params[:email]

    unless modify_params[:password].empty?
      user.password = modify_params[:password]
    end

    if user.save
      flash[:success] = 'User modified successfully'
    else
      flash[:danger] = 'Encountered an error whilst updating the user'
    end

    redirect_to users_path
  end

  def remove
  end

  private

  def user_params
    params[:user]
  end

  def modify_params
    params[:user_modify]
  end
end
