class TasksController < ApplicationController

  get '/tasks/new' do
    if !logged_in?
      redirect '/login'
    else
      @logged_in = logged_in?
      @users = User.all
      @current_user = current_user
      erb :'/tasks/new'
    end
  end

  post '/tasks/new' do
    @failure_message = false
    if !logged_in?
      redirect '/login'
    else
      assignee = User.find_by(:name => params[:assign_to])
      task = Task.new
      task.short_description = params[:short_description]
      task.long_description = params[:long_description] if params[:long_description]
      task.due_date = params[:due_date] if params[:due_date]
      task.owner_id = assignee.id
      task.creator_id = current_user.id
      if task.valid?
        task.save
        redirect "/tasks/#{task.id}"
      else
        errors = task.errors.messages
        @failure_message = validation_messages(errors)
        @users = User.all
        @logged_in = logged_in?
        @current_user = current_user
        erb :'/tasks/new'
      end
    end
  end

  get '/tasks/users/:slug' do
    if !logged_in?
      redirect '/login'
    else
      @logged_in = logged_in?
      @current_user = current_user
      erb :'/tasks/index'
    end
  end

  get '/tasks/:id' do
    if !logged_in?
      redirect '/login'
    else
      @logged_in = logged_in?
      @current_user = current_user
      @task = Task.find(params[:id])
      erb :'/tasks/show'
    end
  end

  get '/tasks/:id/edit' do
    if !logged_in?
      redirect '/login'
    else
      @logged_in = logged_in?
      @user = current_user
      @task = Task.find(params[:id])
      if current_user == @task.creator
        @users = User.all
        @current_user = current_user
        erb :"/tasks/edit"
      else
        @failure_message="Tasks can only be edited by the user that created them."
        erb :"tasks/users/#{current_user.slug}"
      end
    end
  end

  patch '/tasks/:id/edit' do
    @failure_message = false
    if !logged_in?
      redirect '/login'
    else
      assignee = User.find_by(:name => params[:assign_to])
      task = Task.find(params[:id])
      task.short_description = params[:short_description]
      task.long_description = params[:long_description] if params[:long_description]
      task.due_date = params[:due_date] if params[:due_date]
      task.owner_id = assignee.id
      task.creator_id = current_user.id

      if task.valid?
        task.save
        redirect "/tasks/#{task.id}"
      else
        errors = task.errors.messages
        @failure_message = validation_messages(errors)
        @logged_in = logged_in?
        @users = User.all
        @task = Task.find(params[:id])
        @current_user = current_user

        erb :"/tasks/edit"
      end
    end
  end

  patch "/tasks/complete" do
    if !logged_in?
      redirect '/login'
    else
      task = Task.find(params[:task].key("on"))
      task.completed = true
      task.owner_id = nil
      task.save
      redirect "tasks/users/#{current_user.slug}"
    end
  end

  post '/tasks/:id/delete' do
    if !logged_in?
      redirect '/login'
    else
      task = Task.find(params[:id])
      if task.creator == current_user
        Task.find(params[:id]).destroy
        @logged_in = logged_in?
        @current_user = current_user
      else
        @failure_message = "Only the creator of a task may delete that task."
      end
      erb :'/tasks/index'
    end
  end
end
