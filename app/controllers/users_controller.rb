class UsersController < ApplicationController

  get '/users/new' do
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
      erb :'users/new'
    end
  end

  get '/users/index' do
    redirect_if_not_logged_in
    if current_user.is_administrator?
      erb :'users/index'
    else
      redirect "/tasks/users/#{current_user.slug}"
    end
  end

  get '/users/:slug' do
    redirect_if_not_logged_in
    @user = User.find_by_slug(params[:slug])
    supervisor_id = @user.supervisor_id
    @boss = supervisor_id == nil ? "no-one" : User.find(supervisor_id).name
    erb :'users/show'
  end

  get '/users/:id/edit' do
    redirect_if_not_logged_in
    if current_user.is_administrator?
      @user = User.find(params[:id])
      erb :'/users/edit'
    else
      redirect "/tasks/users/#{current_user.slug}"
    end
  end

  patch '/users/:id/edit' do
    redirect_if_not_logged_in
    user_hash = params[:user]
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
      @invalid_entry_message = validation_messages(errors)
      @user = User.find(params[:id])
      erb :'/users/edit'
    end
  end

  post '/users/:id/delete' do
    redirect_if_not_logged_in
    if current_user.is_administrator?
      user = User.find(params[:id])
      if user != current_user
        user.destroy
      end
    end
    redirect '/users/index'
  end
end
