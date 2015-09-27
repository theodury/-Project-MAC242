# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def initialize
    @all_ratings = Movie.all_ratings
    super
  end

  def index
    redirect = false
    redirect = self.sort
    redirect = self.rate
    Movie.find(:all, :order => @sorting ? @sorting : :id).each do |movie|
      if @ratings.keys.include? movie[:rating]
        (@movies ||= [ ]) << movie
      end
    end
    
    if redirect
      redirect_to movies_path(:sort => @sorting, :ratings => @ratings)
    end
    
    session[:sort]    = @sorting
    session[:ratings] = @ratings
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # Look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def sort
    if params[:sort]
      @sorting = params[:sort]
      return false
    elsif session[:sort]
      @sorting = session[:sort]
      return true
    end
  end
  
  def rate
    if params[:ratings]
      @ratings = params[:ratings]
      return false
    elsif session[:ratings]
      @ratings = session[:ratings]
      return true
    else
      @all_ratings.each do |rat|
        (@ratings ||= { })[rat] = 1
      end
      return false
    end
  end

end
