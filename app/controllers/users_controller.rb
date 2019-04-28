class UsersController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users/new' do
    user_hash = params[:user]
    user = User.new(user_hash)
    if user.username != "" && user.email != "" && user.password != "" && !in_use?(user.username)
      if is_existing_supervisor?(params[:supervisor_name])
        user.manager = User.find { |u| u.name == params[:supervisor_name] }
      else
        user.manager = User.create(:username => "placeholder",
          :name => params[:supervisor_name], :password => "placeholder")
      end
      user.save

      redirect '/login'
    else
      @new_user_error = true
      if user.username == ""
        @invalid_entry_message = "You must enter a username. Please try again"
      elsif in_use?(user.username)
        @invalid_entry_message = "That username is already in use, Please try again"
      elseif user.email == ""
        @invalid_entry_message = "You must enter an email address. Please try again"
      elsif user.password == ""
        @invalid_entry_message = "You must enter a password. Please try again"
      end
    end
  end

  helpers do
    def is_existing_supervisor?(name)
      !!User.find { |user| user.manager.name == name }
    end

    def in_use?(username)
      !!User.find { |user| user.manager.name == username }
    end
  end
end
