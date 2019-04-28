describe 'User' do
  before do
    @user1 = User.create(:username => "user 1", :password => "valid_password")
    @user2 = User.create(:username => "user 2")
    @user1.subordinates << @user2
  end

  it 'can tell you its manager' do
    expect(@user2.manager).to eq(@user1)
  end

  it 'can tell you its subordinates' do
    expect(@user1.subordinates).to include(@user2)
  end

  it 'can slug the username' do
    expect(@user1.slug).to eq("user-1")
  end

  it 'can find a user based on the slug' do
    slug = @user1.slug
    expect(User.find_by_slug(slug).username).to eq("user 1")
  end

  it 'has a secure password' do
    expect(@user1.authenticate("invalid_password_attempt")).to eq(false)

    expect(@user1.authenticate("valid_password")).to eq(@user1)
  end
end
