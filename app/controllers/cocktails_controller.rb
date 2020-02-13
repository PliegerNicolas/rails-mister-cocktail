class CocktailsController < ApplicationController
  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)
    if @cocktail.save
      redirect_to cocktail_path(@cocktail.id)
    else
      render :new
    end
  end

  def update
    set_cocktail
    @cocktail.update(cocktail_params)
    redirect_to cocktail_path
  end

  def edit
    set_cocktail
  end

  def destroy
    set_cocktail
    if @cocktail.doses.count < 1
      Cocktail.destroy(@cocktail.id)
      redirect_to cocktails_path
    else
      redirect_to cocktail_path
    end
  end

  def index
    if params[:query].present?
      query = params[:query]
      query_search(query)
    else
      @cocktails = Cocktail.all
    end
  end

  def show
    set_cocktail
    @ingredients = Ingredient.all
  end

  private

  def set_cocktail
    @cocktail = Cocktail.find(params[:id])
  end

  def cocktail_params
    params.require(:cocktail).permit(
      :name,
      :description,
      :cocktail_id,
      :ingredient_id
    )
  end

  def query_search(query)
    @query = query
    # @cocktails = Cocktail.where("name iLike '%#{query}%'")
    cocktails = Cocktail.joins(:doses, :ingredients)
    @cocktails = cocktails.where("ingredients.name iLike '%#{query}%'
                                  or cocktails.name iLike '%#{query}%'").uniq
  end
end
