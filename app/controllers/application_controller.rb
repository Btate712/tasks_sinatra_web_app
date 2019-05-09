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
    redirect '/'
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
      @current_user ||= User.find(session[:user_id])
    end

    def in_use?(username)
      !!User.find_by(username: username)
    end

    def capitalize(input_string)
      output = input_string.chars
      output.first = output.first.upcase
      output.join
    end

    def validation_messages(errors)
      failure_message = ""
      errors.each do |field, message|
        field = field.to_s.split('_').map { |word| word.capitalize }.join (" ")
        failure_message << (field + " " + message.first + ".\n")
      end
    failure_message
    end

    def users
      User.all
    end

    def redirect_if_not_logged_in
      if !logged_in?
        redirect '/login'
      end
    end
  end
end
