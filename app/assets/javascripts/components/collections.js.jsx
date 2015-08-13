var CollectionIndex = React.createClass({
  render: function() {
    return (
      <article className="sm-col-11 md-col-7 mx-auto">
        <h1 className="center">Collections</h1>
        <div className="collection-list">
          {this.props.collections.map(function(collection) {
            return <CollectionItem key={collection.id} data={collection} />;
          })}
          {this.props.collections.length === 0 ?
            <div className="md-col-8 mx-auto mt3 text center border bg-white rounded p3">
              <h3>You don't have any collections yet.</h3>
              <p>Collections help you organize your recipes.</p>
              <p>You can use them for categories, such as salads or pastas, or recipes that might be good for a summer dinner party.</p>
              <p><a href="#newCollection" className="js-modal-trigger btn btn-blue">Create your first collection</a></p>
            </div>
          : null}
        </div>
      </article>
    );
  }
});

var CollectionItem = React.createClass({
  render: function() {
    var photo_url = this.props.data.photo_url;

    var imgClass = " bg-white rounded shadow p2";
    var imgStyle;
    if (photo_url.length > 0) {
      imgClass = " has-img bg-center bg-no-repeat bg-cover";
      var imgStyle = {
        backgroundImage: "url(" + photo_url + ")"
      }
    }

    return (
      <a href={this.props.data.url} className="link-reset">
        <div className={"collection-preview rounded shadow mb2 py3" + imgClass} style={imgStyle}>
          <div className="collection-preview-container center">
            <h2 className="collection-name m0 h1">{this.props.data.name}</h2>
            <div className="lead">{this.props.data.description}</div>
          </div>
        </div>
      </a>
    )
  }
});

var CollectionHeader = React.createClass({
  render: function() {
    var photo_url = this.props.collection.photo_url;
    var rootStyle, actionClass;
    var rootClass = "grey-4 py2"
    var nameClass = "h1";
    if (photo_url.length > 0) {
      rootClass = "has-img bg-center bg-no-repeat bg-cover mb1";
      nameClass = "h0";
      actionClass = "right-align p1 block white p2 mb2 ";
      var rootStyle = {
        backgroundImage: "url(" + photo_url + ")"
      }
    }

    return (
      <header className={"collection-header full-width center " + rootClass} style={rootStyle}>
        <div className={"caps h4 " + actionClass}>
          {this.props.show_edit === true ?
            <a href="#editCollection" className="js-modal-trigger link-reset">Edit · </a>
          : null}
          <a href="#shareCollection" className="js-modal-trigger link-reset">Share</a>
        </div>
        <h1 className={"inline-block collection-name m0 " + nameClass}>{this.props.collection.name}</h1>
        <div className="h3 mt1 mb0">{this.props.collection.description}</div>
        {this.props.show_pub === true ?
          <div className="mt1 mb1 h4 grey-3">Published by {this.props.collection.publisher}</div>
        : null}
      </header>
    )
  }
});
