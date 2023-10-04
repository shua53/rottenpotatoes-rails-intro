class Movie
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
  if ratings_list.present?
    Movie.where(rating: ratings_list)
    else
      # If ratings_list is nil or empty, retrieve ALL movies
      all
    end
  end
 end