class CookController < ApplicationController
  include ApplicationHelper
  include RecipesHelper

  def index
    @recipe = Recipe.find(params[:recipe_id])

    if me_owns_recipe? || @recipe.shared?
      @recipe_step_count = @recipe.instructions.lines.count
      render :index
    else
      flash[:view] = "You can't cook with private recipes!"
      redirect_to root_url
    end
  end
end
