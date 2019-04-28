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
    erb :login
  end

end
