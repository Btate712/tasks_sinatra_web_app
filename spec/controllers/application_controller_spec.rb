describe "Homepage" do
  it 'loads the homepage' do
    get '/'
    expect(last_response.status).to eq(200)
  end

  it 'has links for creating an account and logging in' do
    get '/'
    expect(last_response.body).to include("Sign In")
    expect(last_response.body).to include("Create Account")
  end

  it 'routes to sign in page when "Sign In" button is clicked' do
    visit '/'
    click_button("Sign In")
    expect(page.current_path).to eq('/login')
  end

  it 'routes to signup page when "Create Account" button is clicked' do
    visit '/'
    click_button("Create Account")
    expect(page.current_path).to eq('/users/new')
  end
end

describe "Signup Page" do
  params = {}
  before do
    User.create(:username => "duplicate", :name => "Bob Tate",
    :email => "whatever@wherever.com", :password => "blah")
  end

  it 'loads' do
    visit '/users/new' do
      expect(last_response.status).to eq(200)
    end
  end

  it 'prompts for appropriate user information' do
    visit '/users/new' do
      expect(page.body).to include("User Name:")
      expect(page.body).to include("Full Name:")
      expect(page.body).to include("Supervisor's Name:")
      expect(page.body).to include("Password:")
    end
  end

  it 'has a submit button' do
    visit '/users/new' do
      expect(page.body).to include("Create User")
    end
  end

  it "does not let a user sign up without a username" do
    params[:user] = {
      :username => "",
      :email => "whatever@wherever.com",
      :password => "blah"
    }
    post '/users/new', params
    expect(last_response.body).to include("You must enter a username. Please try again")
  end

  it "does not let a user sign up without an email address" do
    params[:user] = {
      :username => "A Name",
      :email => "",
      :password => "blah"
    }
    post '/users/new', params
    expect(last_response.body).to include("You must enter an email address. Please try again")
  end

  it "does not let a user sign up without a password" do
    params[:user] = {
      :username => "A Name",
      :email => "whatever@wherever.com",
      :password => ""
    }
    post '/users/new', params
    expect(last_response.body).to include("You must enter a password. Please try again")
  end

  it "does not let a user sign up if username is in use" do
    params[:user] = {
      :username => "duplicate",
      :email => "whatever@wherever.com",
      :password => "blah"
    }
    post '/users/new', params
    expect(last_response.body).to include("That username is already in use, Please try again")
  end

  it "creates a new user and directs user to the login page" do
    params[:user] = {
      :name => "John Doe",
      :username => "j_dizzle",
      :email => "random@domain.com",
      :password => "unsafe_password"
    }
    params[:supervisor_name] = "Unique Name"
    post '/users/new', params
    expect(last_response.location).to include("/login")
    expect(User.last.name).to eq("John Doe")
  end

  it "updates data if user already exists in system as a placeholder for someone else's supervisor" do
    User.new(name: "Fake Name", password: "temp", username: "***Placeholder***")
    params[:user] = {
      name: "Fake Name", password: "whatever", username: "***Placeholder***"
    }
    params[:supervisor_name] = "Unique Name"
    post '/users/new', params
    expect(User.find { |user| user.name == "Fake Name" }.supervisor.name).to eq("Unique Name")
  end
end

describe 'Login' do
  before do
    User.create(username: "Real user", password: "Real Password")
  end

  it "prompts for a username and password" do
    get '/login'
    expect(last_response.body).to include("User Name")
    expect(last_response.body).to include("Password")
  end

  it "communicates the login failure and returns to login page if the login fails" do
    params = { username: "Real user", password: "Not the right password" }
    post '/login', params
    expect(last_response.body).to include("Login failed.  Please try again.")
  end

  it "logs the user in and redirects to '/tasks/:username' if login information is valid" do
    params = { username: "Real user", password: "Real Password" }
    post '/login', params
    follow_redirect!
    expect(last_response.body).to include("You are logged in as Real user")
  end

end
