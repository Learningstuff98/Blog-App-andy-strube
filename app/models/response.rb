class Response < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :response_message, presence: true, length: { minimum: 1 }

end
