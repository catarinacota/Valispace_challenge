puts "Creating functions.."

user_1 = User.create!(email: "catarina@hello.com", password: "123456")

Function.create!(user: user_1, name: "f1", content: "f2 + f5")
Function.create!(user: user_1, name: "f2", content: "5 - f4")
Function.create!(user: user_1, name: "f3", content: "f1 - f2")
Function.create!(user: user_1, name: "f4", content: "7")
Function.create!(user: user_1, name: "f5", content: "90 + 1")

puts "Done!"
