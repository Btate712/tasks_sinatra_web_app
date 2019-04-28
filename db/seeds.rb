user1 = User.create(name: "user1", password: "whatever")
user2 = User.create(name: "user2", password: "whatever")
user3 = User.create(name: "user3", password: "whatever")
user4 = User.create(name: "user4", password: "whatever")
user5 = User.create(name: "user5", password: "whatever")
user6 = User.create(name: "user6", password: "whatever")
user7 = User.create(name: "user7", password: "whatever")
user8 = User.create(name: "user8", password: "whatever")
user9 = User.create(name: "user9", password: "whatever")
user10 = User.create(name: "user10", password: "whatever")
user11 = User.create(name: "user11", password: "whatever")

user1.subordinates << user2
user1.subordinates << user3
user1.subordinates << user4
user2.subordinates << user5
user2.subordinates << user6
user4.subordinates << user7
user6.subordinates << user8
user7.subordinates << user9
user8.subordinates << user10
user3.subordinates << user11
