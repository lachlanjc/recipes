import React from 'react'
import PropTypes from 'prop-types'

import RecipesHomeList from './RecipesHomeList'
import RecipesHomeSidebar from './RecipesHomeSidebar'
import SplitLayout from './SplitLayout'

const RecipesHome = ({ recipes = [], groceries = [], collections = [] }) => (
  <SplitLayout
    heading="Recipes"
    sidebar={
      <RecipesHomeSidebar
        recipes={recipes}
        groceries={groceries}
        collections={collections}
      />
    }
    content={<RecipesHomeList recipes={recipes} />}
  />
)

RecipesHome.propTypes = {
  recipes: PropTypes.array.isRequired,
  groceries: PropTypes.array,
  collections: PropTypes.array
}

export default RecipesHome
