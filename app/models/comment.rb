class Comment < ApplicationRecord
  belongs_to :blog
  belongs_to :user
  has_many :responses

  def time_since_post
    seconds = (Time.now - self.created_at).to_i
    minutes = (seconds / 60).to_i
    hours = (minutes / 60).to_i
    days = (hours / 24).to_i
    weeks = (days / 7).to_i
    months = (weeks / 4.333).to_i
    years = (weeks / 52).to_i
    message = ""
    if seconds < 60
      message = "less than a minute ago "
    elsif minutes < 2
      message = "a minute ago "
    elsif minutes < 60
      message = "#{minutes} minutes ago "
    elsif hours < 2
      message = "an hour ago "
    elsif hours < 24
      message = "#{hours} hours ago "
    elsif days < 2
      message = "a day ago "
    elsif days < 32
      message = "#{days} days ago "
    elsif months < 2
      message = "a month ago "
    elsif months < 12
      message = "#{months} months ago "
    elsif years < 2
      message = "a year ago "
    else
      message = "#{years} years ago "
    end
    message
  end

end
