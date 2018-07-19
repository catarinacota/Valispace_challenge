class Function < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: true, format: { with: /[\w-_]+/,
    message: "invalid format. ex: function_1 / function1 / function-1" }
  validates :content, presence: true
end
