class Function < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: true }
  validates :content, presence: true

end
