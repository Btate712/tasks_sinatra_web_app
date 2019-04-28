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

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect 'tasks/#{user.slug}'
    else
      @login_error = true
      erb :login
    end
  end
end
