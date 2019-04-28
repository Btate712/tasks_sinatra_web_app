class TasksController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/tasks/:user_slug' do
    binding.pry
  end
end
