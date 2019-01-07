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
          email: user_params[:email],
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

    unless modify_params[:username].empty?
      user.username = modify_params[:username]
    end

    unless modify_params[:email].empty?
      user.email = modify_params[:email]
    end

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
    user = User.find(user_params)

    if user == current_user
      flash[:danger] = "You can't delete yourself"
    else
      if user.destroy
        flash[:success] = 'User removed successfully'
      else
        flash[:danger] = 'Encountered an error whilst deleting the user'
      end
    end

    redirect_to users_path
  end

  private

  def user_params
    params[:user]
  end

  def modify_params
    params[:user_modify]
  end
end
