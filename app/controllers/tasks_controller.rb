class TasksController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
  end

  get '/tasks/new' do
    if !logged_in?
      redirect '/login'
    else
      @user = current_user
      erb :'/tasks/new'
    end
  end

  get '/tasks/:id' do
    if !logged_in?
      redirect '/login'
    else
      @user = current_user
      @task = Task.find(params[:id])
      erb :'/tasks/show'
    end
  end

  get '/tasks/users/:slug' do
    if !logged_in?
      redirect '/login'
    else
      @user = current_user

      erb :'/tasks/index'
    end
  end

  get '/tasks/:id/edit' do
    if !logged_in?
      redirect '/login'
    else
      @user = current_user
      @task = Task.find(params[:id])
      @users = User.all

      erb :'/tasks/edit'
    end
  end

  post '/tasks/new' do
    @failure_message = false
    if !logged_in?
      redirect '/login'
    elsif !params[:short_description] || params[:short_description] == ""
      @failure_message = "Every task must have an owner."
    elsif !params[:assign_to] || params[:assign_to] == ""
      @failure_message = "Every task must have a short description."
    elsif !User.all.any? { |user| user.name == params[:assign_to] }
      @failure_message = "#{params[:assign_to]} is not a registered user."
    end
    assignee = User.find_by(:name => params[:assign_to])
    if !current_user.can_assign_to?(assignee)
      @failure_message = "You can only assign tasks to yourself or to subordinates"
    end
    if @failure_message
      erb :'/tasks/new'
    else
      task = Task.new
      task.short_description = params[:short_description]
      task.long_description = params[:long_description] if params[:long_description]
      task.due_date = params[:due_date] if params[:due_date]
      task.owner_id = assignee.id
      task.creator_id = current_user.id
      task.save

      redirect "/tasks/#{task.id}"
    end
  end

  post '/tasks/:id/delete' do
    if !logged_in?
      redirect '/login'
    else
      Task.find(params[:id]).destroy
      @user = current_user
      erb :'/tasks/index'
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end
end
