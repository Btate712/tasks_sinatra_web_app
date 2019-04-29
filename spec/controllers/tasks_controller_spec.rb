describe "New Task" do
  before do
    @boss = User.create(username: "boss", name: "boss", password: "boss")
    @worker = User.create(username: "worker", name: "worker", password: "worker")
    @ceo = User.create(username: "ceo", name: "ceo", password: "ceo")
    @boss.subordinates << @worker
    @ceo.subordinates << @boss
  end

  it 'redirects a user who is not logged in to the login page' do
    get '/logout'
    post '/tasks/new'
    follow_redirect!
    expect(last_response.body).to include("Please enter your credentials")
  end

  it 'displays a form with appropriate inputs for creating a task' do
    params = { username: "boss", password: "boss" }
    post '/login', params
    get '/tasks/new'
    expect(last_response.body).to include("Short Description")
    expect(last_response.body).to include("Long Description")
    expect(last_response.body).to include("Due Date")
    expect(last_response.body).to include("Assign to")
  end

  it 'does not create a task without an owner' do
    params = { username: "boss", password: "boss" }
    post '/login', params
    params = { short_description: "task 1", long_description: "task one"}
    post '/tasks/new', params
    expect(last_response.body).to include("Every task must have an owner.")
  end

  it 'does not create a task without a short description' do
    params = { username: "boss", password: "boss" }
    post '/login', params
    params = { assign_to: "worker", long_description: "task one"}
    post '/tasks/new', params
    expect(last_response.body).to include("Every task must have a short description.")
  end

  it 'does not allow a task to be assigned to an owener that is not in the system' do
    params = { username: "boss", password: "boss" }
    post '/login', params
    params = { assign_to: "not in system", short_description: "This shouldn't work" }
    post '/tasks/new', params
    expect(last_response.body).to include("is not a registered user")
  end

  it 'allows a user to assign a task to a subordinate' do
    params = { username: "boss", password: "boss" }
    post '/login', params
    params = {}
    params = { short_description: "Task for subordinate", assign_to: "worker" }
    post '/tasks/new', params
    expect(last_response.body).to include("Task assigned successfully")
  end

  it 'prevents assigning a task to a user who is not subordinate' do
    params = { username: "boss", password: "boss" }
    post '/login', params
    params = {}
    params = { short_description: "Task for subordinate", assign_to: "ceo" }
    post '/tasks/new', params
    expect(last_response.body).to include("You can only assign tasks to yourself or to subordinates")
  end
end
