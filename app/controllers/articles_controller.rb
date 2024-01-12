class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @page = params.fetch(:page, 0).to_i
    per_page = 3  # Number of articles per page
    page_offset = @page * per_page

    @showing_all = TRUE
  
    if params[:query].present?
      @articles = Article.search(params[:query]).limit(per_page).offset(page_offset)
      @showing_all = FALSE
      @num_articles = Article.search(params[:query]).count
    else
      @articles = Article.limit(per_page).offset(page_offset)
      @num_articles = Article.count
    end

    @start_index = page_offset + 1
    @start_index = 0 if @num_articles == 0
    @end_index = page_offset + per_page
    @end_index = @num_articles if @end_index > @num_articles

    # Check if there are more articles beyond this page
    @more_results = @end_index < @num_articles
  end
      
  def new
    @article = Article.new
  end
  
  def create
    @article = Article.new(article_params)
    if @article.save
    redirect_to @article, notice: 'Article was successfully created.'
    else
    render :new
    end
  end
  
  def update
    if @article.update(article_params)
    redirect_to @article, notice: 'Article was successfully updated.'
    else
    render :edit
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path, notice: 'Article was successfully deleted.'
  end
  
  private
  
  def set_article
    @article = Article.find(params[:id])
  end
  
  def article_params
    params.require(:article).permit(:title, :content, :author, :date)
  end
end
