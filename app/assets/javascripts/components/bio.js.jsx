class Bio extends React.Component {
  render() {
    const lachlan = {
      name: "Lachlan Campbell",
      description: "Creator of Noodles, middle schooler, and intern at Highrise HQ.",
      username: "lachlanjc"
    }
    const taran = {
      name: "Taran Samarth",
      description: "Co-founder of Noodles. Hacker, writer, and football geek.",
      username: "tarans22"
    }
    let user = lachlan;
    if (this.props.person == "tns") {
      user = taran;
    }
    return (
      <div className="py2">
        <h3 className="m0">{user.name}</h3>
        <p className="m0">{user.description}</p>
        <a href={"https://twitter.com/" + user.username} className="h5 white bold inline-block px1 rounded bg-orange">
          @{user.username}
        </a>
      </div>
    )
  }
}
