class Subblog < ApplicationRecord
  belongs_to :user
  has_many :blogs

  validates :name, presence: true, length: { minimum: 1 }
  validates :description, presence: true, length: { minimum: 1 }

end
