class Function < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: true, format: { with: /^[a-zA-Z]{1,2}\d{0,5}$/,
  multiline: true, message: "invalid format. ex: f1 / F100 / ff1 / Ff1000" }
  validates :content, presence: true

end
