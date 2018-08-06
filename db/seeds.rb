puts "Creating functions.."

user_1 = User.create!(email: "catarina@hello.com", password: "123456")

Function.create!(user: user_1, name: "f4", content: "7")
Function.create!(user: user_1, name: "f5", content: "90 + 1")
Function.create!(user: user_1, name: "f2", content: "5 - id:#{Function.find_by(name: "f4").id}")
Function.create!(user: user_1, name: "f1", content: "id:#{Function.find_by(name: "f2").id} + id:#{Function.find_by(name: "f5").id}")
Function.create!(user: user_1, name: "f3", content: "id:#{Function.find_by(name: "f1").id} * id:#{Function.find_by(name: "f2").id}")

puts "Done!"
