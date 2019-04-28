describe 'User' do
  before do
    @user1 = User.create(:username => "user 1", :password => "valid_password")
    @user2 = User.create(:username => "user 2")
    @user1.subordinates << @user2
  end

  it 'can tell you its supervisor' do
    expect(@user2.supervisor).to eq(@user1)
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

  it 'can determine whether another user is subordinate on the org chart' do
    user1 = User.create(name: "user1", password: "whatever")
    user2 = User.create(name: "user2", password: "whatever")
    user3 = User.create(name: "user3", password: "whatever")
    user1.subordinates << user2
    user2.subordinates << user3
    expect(user1.can_assign_to?(user2)).to eq(true)
    expect(user1.can_assign_to?(user3)).to eq(true)
    expect(user2.can_assign_to?(user3)).to eq(true)
    expect(user2.can_assign_to?(user1)).to eq(false)
    expect(user3.can_assign_to?(user1)).to eq(false)
    expect(user3.can_assign_to?(user2)).to eq(false)
  end
end
