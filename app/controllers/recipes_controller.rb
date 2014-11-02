class RecipesController < ApplicationController
  before_filter :set_recipe, only: [:show, :edit, :update, :destroy]

  # GET /recipes
  def index
    if current_user
      if params[:filter] == "favorites"
        @recipes = Recipe.where(:user_id => current_user.id, :favorite => true)
      else
        @recipes = Recipe.where(:user_id => current_user.id)
        @favorites_count = @recipes.where(:favorite => true).count
      end
    else
      render "home"
    end
  end

  # GET /recipes/1
  def show
    if @recipe.user_id == current_user.id
      set_recipe
    else
      flash[:view] = "Sorry, you can't look at that recipe."
      redirect_to root_url
    end
  end

  def remove_image
    recipe = Recipe.find(params[:id])

    if current_user && recipe.user_id == current_user.id
      recipe.img = nil
      recipe.save
      redirect_to recipe
    else
      flash[:danger] = "That's not your recipe!"
    end
  end

  def share
    @recipe_id = params[:id]
    @recipe = Recipe.find(@recipe_id)

    if current_user && @recipe.shared == false
      if @recipe.user_id == current_user.id
        @recipe.shared = true
        render 'share'
      else
        flash[:view] = "You can't share recipes that aren't yours!"
        redirect_to root_url
      end
    else
      render 'share'
    end
  end

  def save_to_noodles
    set_recipe

    @save_recipe = Recipe.new do |r|
      r.user_id = current_user.id
      r.title = @recipe.title
      r.description = @recipe.description
      r.img = @recipe.img
      r.ingredients = @recipe.ingredients
      r.instructions = @recipe.instructions
      r.instructions_rendered = @recipe.instructions_rendered
      r.favorite = false
      r.shared = false
      r.save
    end

    flash[:success] = "#{@save_recipe.title} (published by #{User.find(@recipe.user_id).first_name}) has been saved to your Noodles account."
    render :show
  end

  # GET /recipes/new
  def new
    if current_user
      @recipe = Recipe.new
    else
      flash[:info] = "You must sign up or sign in to create new recipes."
      redirect_to root_url
    end
  end

  # GET /recipes/1/edit
  def edit
    if @recipe.user_id == current_user.id
      set_recipe
    else
      flash[:view] = "Sorry, you can't edit that recipe."
      redirect_to root_url
    end
  end

  # Markdown processing
  def markdown(str)
    md = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, underline: true, space_after_headers: true, strikethrough: true)
    return md.render(str)
  end

  # POST /recipes
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    @recipe.shared = false
    @recipe.instructions_rendered = markdown(@recipe.instructions)

    if @recipe.save
      flash[:success] = "Your recipe has been created."
      redirect_to @recipe
    else
      render :new
    end
  end

  # PATCH/PUT /recipes/1
  def update
    @recipe.instructions_rendered = markdown(@recipe.instructions)

    if @recipe.update(recipe_params)
      flash[:success] = "Awesome, your changes have been saved."
      redirect_to @recipe
    else
      render :edit
    end
  end

  # DELETE /recipes/1
  def destroy
    @recipe.destroy
    flash[:danger] = "Your recipe has been deleted."
    redirect_to recipes_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Only allow trusted parameters
    def recipe_params
      params.require(:recipe).permit(:title, :description, :img, :ingredients, :instructions, :favorite)
    end
end
