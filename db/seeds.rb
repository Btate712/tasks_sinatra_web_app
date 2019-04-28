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

task1.creator = bob
task1.owner = bob
task2.creator = bob
task2.owner = frank
task3.creator = bob
task3.owner = wrobo

bob.save
frank.save
wrobo.save

task1.save
task2.save
task3.save
