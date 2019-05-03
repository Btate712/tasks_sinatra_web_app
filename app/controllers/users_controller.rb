class UsersController < ApplicationController

  get '/users/new' do
    @users = User.all
    erb :'users/new'
  end

  post '/users/new' do
    user_hash = params[:user]
    @invalid_entry_message = user_validation_error(user_hash)
    if @invalid_entry_message   # If New User failed input data validation, send
      erb :'users/new'          # user back to login screen with error message
    else
      user = User.create(user_hash)
    end
    redirect '/login'

  end

  get '/users/index' do
    if !logged_in?
      redirect '/login'
    else
      @logged_in = logged_in?
      @users = User.all

      erb :'users/index'
    end
  end

  get '/users/:slug' do
    if !logged_in?
      redirect '/login'
    else
      @logged_in = logged_in?
      @user = User.find_by_slug(params[:slug])
      supervisor_id = @user.supervisor_id
      @boss = supervisor_id == nil ? "no-one" : User.find(supervisor_id).name
      @current_user = current_user

      erb :'users/show'
    end
  end

  get '/users/:id/edit' do
    if !logged_in?
      redirect '/login'
    else
      @logged_in = logged_in?
      @user = User.find(params[:id])
      @users = User.all

      erb :'/users/edit'
    end
  end

  patch '/users/:id/edit' do
    if !logged_in?
      redirect '/login'
    else
      user_hash = params[:user]
      @invalid_entry_message = false
      if user_hash[:email] == ""
        @invalid_entry_message = "You must enter an email address. Please try again."
      elsif user_hash[:name] == ""
        @invalid_entry_message = "You must enter a name.  Please try again"
      end
      if @invalid_entry_message
        @logged_in = logged_in?
        @user = User.find(params[:id])
        @users = User.all
        erb :'/users/edit'
      else
        user = User.find(params[:id])
        user.name = user_hash[:name]
        user.email = user_hash[:email]
        if user_hash[:supervisor_id] && user_hash[:supervisor_id] != ""
          User.find(user_hash[:supervisor_id]).subordinates << user
        else
          user.supervisor_id = nil
          user.save
        end
        #end
        redirect '/users/index'
      end
    end
  end

  post '/users/:id/delete' do
    if !logged_in?
      redirect '/login'
    else
      if current_user.administrator?
        user = User.find(params[:id])

        user.destroy
      end
      redirect '/users/index'
    end
  end

  def user_validation_error(user_hash)

    invalid_entry_message = false
    # Check if all fields are filled in.  If not, redirect to new user page with error message
    if user_hash[:username] == ""
      invalid_entry_message = "You must enter a username. Please try again."
    elsif user_hash[:email] == ""
      invalid_entry_message = "You must enter an email address. Please try again."
    elsif !user_hash[:password] || user_hash[:password] == ""
      invalid_entry_message = "You must enter a password. Please try again."
    # Check if username is already in use.  If so, redirect to new user page with error message
    elsif in_use?(user_hash[:username])
      invalid_entry_message = "That username is already in use, Please try again."
    end
    invalid_entry_message
  end

end
