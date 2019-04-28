describe 'Task' do
  before do
    @user1 = User.create(:name => "Bob", :password => "password")
    @user2 = User.create(:name => "Frank", :password => "password")
    @task1 = Task.create(short_description: "A self-assigned task",
      creator_id: @user1.id, owner_id: @user1.id)
    @task2 = Task.create(short_description: "A self-assigned task",
      creator_id: @user1.id, owner_id: @user2.id)
    @user1.save
    @user2.save
  end

  it 'can tell you its owner' do
    expect(@task1.owner).to eq(@user1)
  end

  it 'can tell you its creator' do
    expect(@task1.creator).to eq(@user1)
  end
end
