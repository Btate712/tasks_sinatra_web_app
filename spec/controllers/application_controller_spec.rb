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
  before do
    User.create(:username => "duplicate", :email => "whatever@wherever.com",
    :password => "blah")
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

  it "directs user to the login page" do
    params = {
      :name => "John Doe",
      :email => "random@domain.com"
      :password => "unsafe_password"
    }
    post '/users/new', params
    expect(last_response.location).to include("/login")
  end

  it "does not let a user sign up without a username" do
    params = {
      :username => "",
      :email => "whatever@wherever.com",
      :password => "blah"
    }
    post '/users/new', params
    expect(last_response.body).to include("You must enter a username. Please try again")
  end

  it "does not let a user sign up without an email address" do
    params = {
      :username => "A Name",
      :email => "",
      :password => "blah"
    }
    post '/users/new', params
    expect(last_response.body).to include("You must enter an email address. Please try again")
  end

  it "does not let a user sign up without a password" do
    params = {
      :username => "A Name",
      :email => "whatever@wherever.com",
      :password => ""
    }
    post '/users/new', params
    expect(last_response.body).to include("You must enter a password. Please try again")
  end

  it "does not let a user sign up if username is in use" do
    params = {
      :username => "duplicate",
      :email => "whatever@wherever.com",
      :password => "blah"
    }
    post '/users/new', params
    expect(last_response.body).to include("That username is already in use, Please try again")
  end
end
