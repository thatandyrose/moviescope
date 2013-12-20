class ShowTime < ActiveRecord::Base
  attr_accessible :cinema_id, :movie_id, :showing_at
end
