class MoviesController < ApplicationController
  
  def index
    title = "%"
    director = "%"
    runtime = ""

    @movies = Movie.all
    if params[:runtime_in_minutes].present?
      runtime = @movies.runtime(params[:runtime_in_minutes])
    end
    if params[:title].present?
      title =  "%#{params[:title]}%"
    end
    if params[:director].present?
      director =  "%#{params[:director]}%"
    end
    @movies = @movies.where("title LIKE ?", title).where("director LIKE ?", director).where(runtime)
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  protected

  def movie_params
    params.require(:movie).permit(
      :title, :release_date, :director, :runtime_in_minutes, :description, :image
    )
  end

end