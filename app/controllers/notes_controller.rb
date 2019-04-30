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
    #create new note using input from params hash
    if !logged_in?
      redirect '/login'
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
      #perform route function
      @note = Note.find(params[:id])

      erb :'notes/show'
    end
  end

  get '/notes/:id/edit' do
    if !logged_in?
      redirect '/login'
    else
      #perform route function
    end
  end

  patch '/notes/:id/edit' do
    if !logged_in?
      redirect '/login'
    else
      #perform route function
      @note = Note.find(params[:id])
      erb :'notes/edit'
    end
  end

  post '/notes/:id/delete' do
    if !logged_in?
      redirect '/login'
    else
      #perform route function
      @note = Note.find(params[:id])
      @task = @note.task
      @note.destroy

      erb :'/tasks/show'
    end
  end
end
