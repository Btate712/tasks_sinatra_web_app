class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV["SESSION_SECRET"]
  end

  get '/' do
    if logged_in?
      redirect "/tasks/users/#{current_user.slug}"
    else
      erb :index
    end
  end

  get '/login' do
    @login_error = false
    erb :login
  end

  get '/logout' do
    if logged_in?
      session[:user_id] = nil
    end
    redirect'/'
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tasks/users/#{user.slug}"
    else
      @login_error = true
      erb :login
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def existing_supervisor(name)
      supervisor = User.all.find { |user| user.supervisor_id != nil && user.supervisor.name == name }
      if supervisor
        supervisor.id
      end
    end

    def in_use?(username)
      !!User.all.find { |user| user.username == username }
    end

    def exists_as_placeholder?(name)
      !!User.all.find { |user| user.name == name }
    end
  end
end
