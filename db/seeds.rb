bob = User.create(username: "bob", password: "temp", email: "bob@gmail.com", name: "Bob")
frank = User.create(username: "frank", password: "temp", email: "frank@gmail.com", name: "Frank")
jmike = User.create(username: "jmike", password: "temp", email: "jmike@gmail.com", name: "J. Mike")
del = User.create(username: "delroy", password: "temp", email: "delroy@gmail.com", name: "Del")

del.subordinates << jmike
jmike.subordinates << bob
bob.subordinates << frank
