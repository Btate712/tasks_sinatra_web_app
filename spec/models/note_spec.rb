describe "Note" do
  before do
    @user1 = User.create(name: "Bob", username: "bob", password: "password")
    @user2 = User.create(name: "Bob2", username: "bob2", password: "password2")
    @task1 = Task.create(short_description: "some description", owner_id: @user1.id)
    @task2 = Task.create(short_description: "some other description", owner_id: @user2.id)
    @note1 = Note.create(task_id: @task1.id, content: "some content", user_id: @user1.id)
    @note2 = Note.create(task_id: @task2.id, content: "some other content", user_id: @user2.id)

  end

  it 'can tell you the name of the user who wrote it' do
    expect(@note1.user.name).to eq("Bob")
  end

  it 'can give you the short description of the task it belongs to' do
    expect(@note1.task.short_description).to eq("some description")
  end

  # it 'can be edited by the user who wrote it' do
  #   params = { username: "bob", password: "password" }
  #   post '/login', params
  #   params = { content: "some different content" }
  #   patch "notes/#{@task1.id}/edit" # this doesn't work because params (above) goes out of scope
  #   expect(@task1.short_description).to eq("some different content")
  # end

  # it 'cannot be edited by anyone except the user who wrote it' do
  #   params = { username: "bob", password: "password" }
  #   post '/login', params
  #   params = { content: "some different content"}
  #   patch "notes/#{@task2.id}/edit" # this doesn't work because params (above) goes out of scope
  #   expect(@task2.short_description).to eq("some other content")
  # end

end
