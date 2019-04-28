bob = User.create(name: "Bob")
frank = User.create(name: "Frank")
wrobo = User.create(name: "Wrobo")

bob.save
frank.save
wrobo.save

frank.manager = bob
wrobo.manager = bob

task1 = Task.new(short_description: "Task #1")
task2 = Task.new(short_description: "Task #2")
task3 = Task.new(short_description: "Task #3")

bob.owned_tasks << task1
bob.created_tasks << task2
