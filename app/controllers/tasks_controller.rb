class TasksController < ApplicationController

  get '/tasks/new' do
    redirect_if_not_logged_in
    erb :'/tasks/new'
  end

  post '/tasks/new' do
    @failure_message = false
    redirect_if_not_logged_in
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
      erb :'/tasks/new'
    end
  end

  get '/tasks/index' do
    redirect_if_not_logged_in
    erb :'/tasks/index'
  end

  get '/tasks/:id' do
    redirect_if_not_logged_in
    @task = Task.find(params[:id])
    erb :'/tasks/show'
  end

  get '/tasks/:id/edit' do
    redirect_if_not_logged_in
    @task = Task.find(params[:id])
    if current_user == @task.creator
      erb :"/tasks/edit"
    else
      @failure_message="Tasks can only be edited by the user that created them."
      redirect "tasks/index"
    end
  end

  patch '/tasks/:id/edit' do
    @failure_message = false
    task = Task.find(params[:id])
    if !logged_in? && task.creator != current_user
      redirect '/login'
    else
      assignee = User.find_by(:name => params[:assign_to])
      task = Task.find(params[:id])
      task.short_description = params[:short_description]
      task.long_description = params[:long_description] if params[:long_description]
      task.due_date = params[:due_date] if params[:due_date]
      task.owner_id = assignee.id

      if task.valid?
        task.save
        redirect "/tasks/#{task.id}"
      else
        errors = task.errors.messages
        @failure_message = validation_messages(errors)
        @task = Task.find(params[:id])
        erb :"/tasks/edit"
      end
    end
  end

  patch "/tasks/complete" do
    redirect_if_not_logged_in
    task = Task.find(params[:task].key("on"))
    task.completed = true
    task.save
    redirect "tasks/index"
  end

  patch "/tasks/:id/reject" do
    task = Task.find(params[:id])
    task.completed = false
    task.save
    redirect "tasks/index"
  end

  post '/tasks/:id/delete' do
    redirect_if_not_logged_in
    task = Task.find(params[:id])
    if task.creator == current_user
      Task.find(params[:id]).destroy
    else
      @failure_message = "Only the creator of a task may delete that task."
    end
    erb :'/tasks/index'
  end
end
