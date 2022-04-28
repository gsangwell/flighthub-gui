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

        if run_appliance_menu_cmd('userCreate', user)[:output]["status"]
          set_password(user_params)

          unless user_params[:ssh_key].nil?
            add_ssh_key(user_params)
          end

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
    modifications = []

    unless modify_params[:password].empty?
      modifications << 'changed password' if set_password(modify_params)
    end

    unless modify_params[:ssh_key].empty?
      modifications << 'added SSH key' if add_ssh_key(modify_params)
    end

    unless modifications.empty?
      flash[:success] = "Successfully #{modifications.join(' and ')} for #{modify_params[:username]}"
    end

    redirect_to users_path
  end

  def remove
    user = User.find_by_username(user_params)

    if user_params == current_user.username
      flash[:danger] = "You can't delete yourself"
    else
      user_deletion_data = JSON.generate(
        {
          "user-name": user_params,
          "delete": true
        }
      )

     if run_appliance_menu_cmd('userDelete', user_deletion_data)[:output]["status"]
        user.destroy if user
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

  def add_ssh_key(params)
    user_key_data = JSON.generate(
      {
        "user-name": params[:username],
        "key": params[:ssh_key]
      }
    )

    if run_appliance_menu_cmd('userAddKey', user_key_data)[:output]["status"]
      return true
    else
      flash[:danger] = 'Encountered an error whilst adding the SSH key'
    end
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

    if run_appliance_menu_cmd('userSetPasswd', user_password_data)[:output]["status"]
      return true
    else
      flash[:danger] = 'Encountered an error whilst setting the password'
    end
  end
end
