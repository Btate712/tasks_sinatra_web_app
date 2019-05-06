class NotesController < ApplicationController

  get '/notes/task/:task_id/new' do
    if !logged_in?
      redirect '/login'
    else
      @current_user = current_user
      @logged_in = logged_in?
      @task_id = params[:task_id]
      erb :'/notes/new'
    end
  end

  post '/notes/new' do
    #create new note using input from params hash
    if !logged_in?
      redirect '/login'
    elsif params[:content] == ""
      @current_user = current_user
      @logged_in = logged_in?
      @failure_message = "Notes must have content. Please try again."
      @task_id = params[:task_id]
      erb :'/notes/new'
    else
      #perform route function
      note = Note.new
      note.content = params[:content]
      note.task_id = params[:task_id]
      note.user = current_user
      note.save

      redirect "/tasks/#{params[:task_id]}"
    end
  end

  get '/notes/:id' do
    if !logged_in?
      redirect '/login'
    else
      @logged_in = logged_in?
      @note = Note.find(params[:id])
      @current_user = current_user
      erb :'notes/show'
    end
  end

  get '/notes/:id/edit' do
    if !logged_in?
      redirect '/login'
    else
      @current_user = current_user
      @logged_in = logged_in?
      @note = Note.find(params[:id])
      erb :'notes/edit'
    end
  end

  patch '/notes/:id/edit' do
    if !logged_in?
      redirect '/login'
    elsif params[:content] == ""
      @current_user = current_user
      @logged_in = logged_in?
      @failure_message = "Notes must have content. Please try again."
      @task_id = params[:task_id]
      erb :"/notes/#{params[:id]}/edit"
    else
      #perform route function
      note = Note.find(params[:id])
      note.content = params[:content]
      note.task_id = params[:task_id]
      note.user = current_user
      note.save

      redirect "/tasks/#{params[:task_id]}"
    end
  end

  post '/notes/:id/delete' do
    if !logged_in?
      redirect '/login'
    else
      @current_user = current_user
      @logged_in = logged_in?
      @note = Note.find(params[:id])
      @task = @note.task
      @note.destroy

      erb :'/tasks/show'
    end
  end
end
