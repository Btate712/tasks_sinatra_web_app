describe "Note" do
  before do
    @user1 = User.create(name: "Bob", password: "password")
    @task1 = Task.create(short_description: "some description", owner_id: @user1.id)
    @note1 = Note.create(task_id: @task1.id, content: "some content", user_id: @user1.id)
  end

  it 'can tell you the name of the user who wrote it' do
    expect(@note1.user.name).to eq("Bob")
  end

  it 'can give you the short description of the task it belongs to' do
    expect(@note1.task.short_description).to eq("some description")
  end

end
