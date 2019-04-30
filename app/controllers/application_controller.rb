class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions_secret, SecureRandom.hex(64)
  end

  get '/' do
    erb :index
  end

  get '/login' do
    @login_error = false
    erb :login
  end

  get '/logout' do
    if logged_in?
      session[:user_id] = nil
    end
    redirect '/index'
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

    def is_existing_supervisor?(name)
        !!User.all.find { |user| user.supervisor_id != nil && user.supervisor.name == name }
    end

    def in_use?(username)
      !!User.all.find { |user| user.username == username }
    end

    def exists_as_placeholder?(name)
      !!User.all.find { |user| user.name == name }
    end
  end
end
