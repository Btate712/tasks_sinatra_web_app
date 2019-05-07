class UsersController < ApplicationController

  get '/users/new' do
    @users = User.all
    erb :'users/new'
  end

  post '/users/new' do
    user_hash = params[:user]
    supervisor = User.find_by(name: params[:supervisor_name])
    if supervisor
      user_hash[:supervisor_id] = supervisor.id
    end
    user = User.new(user_hash)
    if user.valid?
      user.save
      redirect '/login'
    else
      errors = user.errors.messages
      @invalid_entry_message = validation_messages(errors)
      @users = User.all
      erb :'users/new'
    end
  end

  get '/users/index' do
    if !logged_in?
      redirect '/login'
    else
      if current_user.is_administrator?
        @current_user = current_user
        @logged_in = logged_in?
        @users = User.all
        erb :'users/index'
      else
        redirect "/tasks/users/#{current_user.slug}"
      end
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
      if current_user.is_administrator?
        @current_user = current_user
        @logged_in = logged_in?
        @user = User.find(params[:id])
        @users = User.all
        erb :'/users/edit'
      else
        redirect "/tasks/users/#{current_user.slug}"
      end
    end
  end

  patch '/users/:id/edit' do
    if !logged_in?
      redirect '/login'
    else
      user = User.find(params[:id])
      user.name = user_hash[:name]
      user.email = user_hash[:email]
      if user_hash[:supervisor_id] && user_hash[:supervisor_id] != ""
        User.find(user_hash[:supervisor_id]).subordinates << user
      else
        user.supervisor_id = nil
      end
      if user.valid?
        user.save
        redirect '/users/index'
      else
        errors = user.errors.messages
        @invalid_entry_message = validation_messages(error)
        @current_user = current_user
        @logged_in = logged_in?
        @user = User.find(params[:id])
        @users = User.all
        erb :'/users/edit'
      end
    end
  end

  post '/users/:id/delete' do
    if !logged_in?
      redirect '/login'
    else
      if current_user.is_administrator?
        user = User.find(params[:id])
        user.destroy
      end
      redirect '/users/index'
    end
  end
end
