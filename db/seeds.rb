user1 = User.create(name: "user 1", username: "user 1", password: "whatever")
user2 = User.create(name: "user 2", username: "user 2", password: "whatever")
user3 = User.create(name: "user 3", username: "user 3", password: "whatever")
user4 = User.create(name: "user 4", username: "user 4", password: "whatever")
user5 = User.create(name: "user 5", username: "user 5", password: "whatever")
user6 = User.create(name: "user 6", username: "user 6", password: "whatever")
user7 = User.create(name: "user 7", username: "user 7", password: "whatever")
user8 = User.create(name: "user 8", username: "user 8", password: "whatever")
user9 = User.create(name: "user 9", username: "user 9", password: "whatever")
user10 = User.create(name: "user 10", username: "user 10", password: "whatever")
user11 = User.create(name: "user 11", username: "user 11", password: "whatever")

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
