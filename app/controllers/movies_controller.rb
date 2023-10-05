class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  
  
  def index
    @all_ratings = Movie.all_ratings
  
    # Check if ratings are in params or session
    if params.has_key?(:ratings)
      @ratings_to_show = params[:ratings].keys
      session[:ratings] = @ratings_to_show # Store in session
    elsif session.key?(:ratings)
      @ratings_to_show = session[:ratings]
      params[:ratings] = Hash[@ratings_to_show.collect { |key| [key, '1'] }]
    else
      @ratings_to_show = @all_ratings
    end
  
    # Check if sort_by is in params or session
    if params.has_key?(:sort_by)
      @movies = Movie.with_ratings(@ratings_to_show).order(params[:sort_by])
      session[:sort_by] = params[:sort_by] # Store in session
    elsif session.key?(:sort_by)
      # Redirect to RESTful route with the sort_by from session
      redirect_to movies_path(sort_by: session[:sort_by], ratings: Hash[@ratings_to_show.collect { |key| [key, '1'] }])
      return
    else
      @movies = Movie.with_ratings(@ratings_to_show)
    end
  
    # Set sorting headers
    @title_header = 'hilite bg-warning' if params[:sort_by] == 'title' || session[:sort_by] == 'title'
    @release_date_header = 'hilite bg-warning' if params[:sort_by] == 'release_date' || session[:sort_by] == 'release_date'
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
