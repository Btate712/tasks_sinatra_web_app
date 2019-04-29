class TasksController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
  end

  get '/tasks/:slug' do
    @user = User.find_by_slug(params[:slug])

    erb :'/tasks/index'
  end

  get '/tasks/new' do
    erb :'/tasks/new'
  end

  post '/tasks/new' do
    binding.pry
  end
end
