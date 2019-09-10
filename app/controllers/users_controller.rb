class UsersController < ApplicationController
  require 'json'
  require 'securerandom'

  def index
    @users = run_appliance_menu_cmd('userGetList')[:output]["users"]
      .sort.map { |u| u.gsub(/\(.*?\)/, "") }
  end

  def create
    user = User.find_by(username: user_params[:username])
    unless user
      if user_params[:password] == user_params[:password_confirmation]
        user = JSON.generate(
          {
            "user-name": user_params[:username],
            "full-name": user_params[:full_name]
          }
        )

        unless user_params[:ssh_key].nil?
          set_ssh_key(user_params)
        end

        if run_appliance_menu_cmd('userCreate', user)[:output]["status"]
          set_password(user_params)
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
    # TODO: Change this when password functionality is added
    unless modify_params[:password].empty?
      user.password = modify_params[:password]
    end

    unless modify_params[:ssh_key].empty?
      set_ssh_key(modify_params)
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

  def set_ssh_key(params)
    user_key_data = JSON.generate(
      {
        "user-name": params[:username],
        "key": params[:ssh_key]
      }
    )

    run_appliance_menu_cmd('userSetKey', user_key_data)[:output]["status"]
  end

  def set_password(params)
    user_password_data = JSON.generate(
      {
        "user-name": params[:username],
        "passwd": params[:password].crypt(
          '$6$' + SecureRandom.random_number(36 ** 8).to_s(36)
        )
      }
    )

    unless run_appliance_menu_cmd('userSetPasswd', user_password_data)[:output]["status"]
      flash[:danger] = 'Encountered an error whilst setting the password'
    end
  end
end
