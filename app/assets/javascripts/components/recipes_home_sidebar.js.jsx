
const RecipesHomeSidebar = ({
  collections = [],
  hideCollections = false,
  ...props
}) =>
  <div className='dn-p'>
    <Button
      primary
      color='blue'
      href='/recipes/new'
      children='New recipe'
    />
    <Spacer
      x={16}
      y={16}
      className='dib db-ns'
    />
    <Button
      primary
      color='purple'
      href='#import'
      data-behavior='modal_trigger'
      children='Import'
    />
    <Spacer
      x={16}
      y={16}
      className='dib db-ns'
    />
    <Button
      primary
      color='orange'
      href='/explore'
      children='Explore'
      className='mtm mtn-ns'
    />
    <CollectionsMini
      collections={collections}
      hidden={hideCollections}
    />
  </div>

RecipesHomeSidebar.propTypes = {
  collections: React.PropTypes.array,
  hideCollections: React.PropTypes.bool
}
