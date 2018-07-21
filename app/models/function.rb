class Function < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: true, format: { with: /\A[\w-]+\z/,
    message: "invalid format. ex: f_1 / f1 / f-1" }
  validates :content, presence: true

end
