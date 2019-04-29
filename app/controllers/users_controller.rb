class UsersController < ApplicationController

  get '/users/new' do
    erb :'users/new'
  end

  post '/users/new' do
    user_hash = params[:user]
    @invalid_entry_message = false
    # Check if all fields are filled in.  If not, redirect to new user page with error message
    if user_hash[:username] == ""
      @invalid_entry_message = "You must enter a username. Please try again."
    elsif user_hash[:email] == ""
      @invalid_entry_message = "You must enter an email address. Please try again."
    elsif !user_hash[:password] || user_hash[:password] == ""
      @invalid_entry_message = "You must enter a password. Please try again."
    # Check if username is already in use.  If so, redirect to new user page with error message
    elsif in_use?(user_hash[:username])
      @invalid_entry_message = "That username is already in use, Please try again."
    end
    if @invalid_entry_message
      erb :'users/new'
    else
      # Check if supervisor inputted by user exists.  If so, update user hash with supervisor_id
      if is_existing_supervisor?(params[:supervisor_name])
        params[:user][:supervisor_id] = User.find { |user| user.name == params[:supervisor_name] }.id
      end
      # => If not, create Supervisor as new user with placeholder data and update user hash with
      # => newly created Supervisor's id
      supervisor = User.create(name: params[:supervisor_name], password: "temp",
                    username: "***Placeholder***")
      user_hash[:supervisor_id] = supervisor.id
      # Check if new user already exists in the system as a placeholder for a subordinate
      if exists_as_placeholder?(user_hash[:name])
        # => If so, update placeholder user with new user information
        user = User.all.find { |u| u.name == user_hash[:name] }
        user_hash.each { |key, value| user[key] = value }
        user.save
      else
      # => If not, create new user
        user = User.create(user_hash)
      end
      # Redirect to login page
      redirect '/login'
    end
  end

  helpers do
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
