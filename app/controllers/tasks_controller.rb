class TasksController < ApplicationController

  get '/tasks/new' do
    if !logged_in?
      redirect '/login'
    else
      @logged_in = logged_in?
      @users = User.all
      @user = current_user
      erb :'/tasks/new'
    end
  end

  post '/tasks/new' do
    @failure_message = false
    if !logged_in?
      redirect '/login'
    elsif !params[:short_description] || params[:short_description] == ""
      @failure_message = "Every task must have a short description."
    elsif !params[:assign_to] || params[:assign_to] == ""
      @failure_message = "Every task must have an owner."
    elsif !User.all.any? { |user| user.name == params[:assign_to] }
      @failure_message = "#{params[:assign_to]} is not a registered user."
    elsif !current_user.can_assign_to?(assignee = User.find_by(:name => params[:assign_to]))
      @failure_message = "You can only assign tasks to yourself or to subordinates"
    end
    if @failure_message
      @users = User.all
      @logged_in = logged_in?
      @user = current_user
      erb :'/tasks/new'
    else
      assignee = User.find_by(:name => params[:assign_to])
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

  get '/tasks/users/:slug' do
    if !logged_in?
      redirect '/login'
    else
      @logged_in = logged_in?
      @user = current_user

      erb :'/tasks/index'

    end
  end

  get '/tasks/:id' do
    if !logged_in?
      redirect '/login'
    else
      @logged_in = logged_in?
      @user = current_user
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
        erb :"/tasks/edit"
      else
        @failure_message="Tasks can only be edited by the user that created them."
        redirect "tasks/users/#{current_user.slug}"
      end
    end
  end

  patch '/tasks/:id/edit' do
    @failure_message = false
    if !logged_in?
      redirect '/login'
    elsif !params[:short_description] || params[:short_description] == ""
      @failure_message = "Every task must have a short_description."
    elsif !params[:assign_to] || params[:assign_to] == ""
      @failure_message = "Every task must have an owner."
    elsif !User.all.any? { |user| user.name == params[:assign_to] }
      @failure_message = "#{params[:assign_to]} is not a registered user."
    elsif !current_user.can_assign_to?(User.find_by(:name => params[:assign_to]))
      @failure_message = "You can only assign tasks to yourself or to subordinates"
    end
    if @failure_message
      @logged_in = logged_in?
      @users = User.all
      @task = Task.find(params[:id])

      erb :"/tasks/edit"
    else
      assignee = User.find_by(:name => params[:assign_to])
      task = Task.find(params[:id])
      task.short_description = params[:short_description]
      task.long_description = params[:long_description] if params[:long_description]
      task.due_date = params[:due_date] if params[:due_date]
      task.owner_id = assignee.id
      task.creator_id = current_user.id
      task.save

      redirect "/tasks/#{task.id}"
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
        @user = current_user
      else
        @failure_message = "Only the creator of a task may delete that task."
      end
      erb :'/tasks/index'
    end
  end
end
