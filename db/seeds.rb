puts "Creating functions.."

user_1 = User.create!(email: "catarina@hello.com", password: "123456")

Function.create!(user: user_1, name: "f1", content: "90")
Function.create!(user: user_1, name: "f2", content: "id:#{Function.find_by(name: "f1").id} + 2")
Function.create!(user: user_1, name: "f3", content: "id:#{Function.find_by(name: "f2").id}")

# a = Function.find_by(name: "f1")
# print(a.id)

# f4 = Function.create!(user: user_1, name: "f4", value: 7)
# f5 = Function.create!(user: user_1, name: "f5", value: 90 + 1)
# f2 = Function.create!(user: user_1, name: "f2", value: 5 - f4.value)



puts "Done!"
