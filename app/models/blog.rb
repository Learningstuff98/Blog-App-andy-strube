class Blog < ApplicationRecord
  belongs_to :subblog
  belongs_to :user

  validates :title, presence: true, length: { minimum: 1 }
  validates :content, presence: true, length: { minimum: 1 }

end
