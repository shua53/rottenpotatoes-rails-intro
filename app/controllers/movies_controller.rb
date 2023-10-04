class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
  
    # Check if the user has explicitly set new sorting/filtering settings in params
    if params[:ratings] || params[:sort_by]
      @ratings_to_show = params[:ratings].keys if params[:ratings]
      @ratings_to_show_hash = Hash[@ratings_to_show.collect { |key| [key, '1'] }] if @ratings_to_show
      session[:ratings] = @ratings_to_show
      session[:sort_by] = params[:sort_by]
    else
      # If no params were passed for sorting or filtering, check if there are settings stored in session
      @ratings_to_show = session[:ratings]
      @ratings_to_show_hash = Hash[@ratings_to_show.collect { |key| [key, '1'] }] if @ratings_to_show
    end
  
    # Retrieve movies based on filtering settings or show all movies if no filters are applied
    if @ratings_to_show
      @movies = Movie.with_ratings(@ratings_to_show)
    else
      @movies = Movie.all
    end
  
    # Sort movies based on sort_by parameter or session settings
    @title_header = ''
    @release_date_header = ''
    if params[:sort_by]
      @movies = @movies.order(params[:sort_by])
      @title_header = 'hilite bg-warning' if params[:sort_by] == 'title'
      @release_date_header = 'hilite bg-warning' if params[:sort_by] == 'release_date'
    elsif session[:sort_by]
      @movies = @movies.order(session[:sort_by])
      @title_header = 'hilite bg-warning' if session[:sort_by] == 'title'
      @release_date_header = 'hilite bg-warning' if session[:sort_by] == 'release_date'
    end
  end
  
  

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end