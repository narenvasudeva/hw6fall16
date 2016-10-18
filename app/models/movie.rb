class Movie < ActiveRecord::Base
  class Movie::InvalidKeyError < StandardError; end
    
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def self.find_in_tmdb(title)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    begin
      if title.empty?
        return [].as_json
      end
      matching_movies = Tmdb::Movie.find(title)
      matching_movies.as_json
      #my_array = []
      #matching_movies.each do |matching_movie|
      #  my_array << matching_movie.as_json
      #end
      matching_movies.as_json
    rescue NoMethodError => tmdb_gem_exception
      if Tmdb::Api.response['code'] == '401'
        raise Movie::InvalidKeyError, 'Invalid API key'
      else
        raise tmdb_gem_exception
      end
    end
  end
   
  def self.create_from_tmdb(movie_id)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    temp_movie = Tmdb::Movie.detail(movie_id)
    movie = Movie.new
    movie.title = temp_movie["title"]
    movie.rating = "R"
    movie.release_date = temp_movie["release_date"]
    movie.save
  end
end
