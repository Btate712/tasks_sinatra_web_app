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
    session[:user_id] = nil
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

    def in_use?(username)
      !!User.all.find { |user| user.username == username }
    end

    def capitalize(input_string)
      output = input_string.chars
      output[0] = output[0].upcase
      output.join
    end

  end
end
