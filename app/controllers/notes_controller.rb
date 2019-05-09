class NotesController < ApplicationController

  get '/notes/task/:task_id/new' do
    if !logged_in?
      redirect '/login'
    else
      @task_id = params[:task_id]
      erb :'/notes/new'
    end
  end

  post '/notes/new' do
    if !logged_in?
      redirect '/login'
    else
      note = Note.new
      note.content = params[:content]
      note.task_id = params[:task_id]
      note.user = current_user
      if note.valid?
        note.save
        redirect "/tasks/#{params[:task_id]}"
      else
        errors = note.errors.messages
        @failure_message = validation_messages(errors)
        @task_id = params[:task_id]
        erb :'/notes/new'
      end
    end
  end

  get '/notes/:id' do
    if !logged_in?
      redirect '/login'
    else
      @note = Note.find(params[:id])
      erb :'notes/show'
    end
  end

  get '/notes/:id/edit' do
    if !logged_in?
      redirect '/login'
    else
      @note = Note.find(params[:id])
      erb :'notes/edit'
    end
  end

  patch '/notes/:id/edit' do
    if !logged_in?
      redirect '/login'
    else
      note = Note.find(params[:id])
      note.content = params[:content]
      note.task_id = params[:task_id]
      note.user = current_user
      if note.valid?
        note.save
        redirect "/tasks/#{params[:task_id]}"
      else
        errors = note.errors.messages
        @failure_message = validation_messages(error)
        @task_id = params[:task_id]
        @note = note
        erb :"/notes/edit"
      end
    end
  end

  post '/notes/:id/delete' do
    if !logged_in?
      redirect '/login'
    else
      @note = Note.find(params[:id])
      @task = @note.task
      if @note.user == current_user
        @note.destroy
      end
      erb :'/tasks/show'
    end
  end
end
