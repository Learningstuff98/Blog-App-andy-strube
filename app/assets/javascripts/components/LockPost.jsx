class LockPost extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      is_locked: false
    }
  }

  componentDidMount() {
    this.getLockedStatus();
  }

  setLockedStatusInState(res) {
    this.setState({
      is_locked: res.data.is_locked
    });
  }

  getLockedStatus() {
    axios.get('http://localhost:3000/moderator/locks/' + this.props.lock_id)
    //axios.get('https://blog-app-andy-strube.herokuapp.com/moderator/locks/' + this.props.lock_id)
    .then((res) => {
      this.setLockedStatusInState(res);
    })
    .catch((err) => console.log(err.response.data));
  }

  invertLockedStatus() {
    this.invertLockedStatusInTheDataBase();
    this.invertLockedStatusInState();
  }

  invertLockedStatusInTheDataBase() {
    axios.patch('http://localhost:3000/moderator/locks/' + this.props.lock_id, {
    //axios.patch('https://blog-app-andy-strube.herokuapp.com/moderator/locks/' + this.props.lock_id, {
      is_locked: !this.state.is_locked
    })
    .catch((err) => console.log(err.response.data));
  }

  invertLockedStatusInState() {
    this.setState({
      is_locked: !this.state.is_locked
    });
  }

  invertLockedStatusButton() {
    if(this.props.is_moderator) {
      if(this.state.is_locked) {
        return(
          <div onClick={() => this.invertLockedStatus()} className="btn btn-primary make-it-green">
            Unlock Post
          </div>
        )
      } else {
        return(
          <div onClick={() => this.invertLockedStatus()} className="btn btn-primary make-it-green">
            Lock Post
          </div>
        )
      }
    }
  }

  render() {
    let lockedNotice;
    if(this.state.is_locked) {
      lockedNotice = <div className='make-it-green'>
        <h3>This post is locked. You won't be able to comment Ps: If anyone is viewing this, I haven't locked the comments for locked posts yet</h3>
        <br/>
      </div>
    }
    return(
      <div>
        {lockedNotice}
        {this.invertLockedStatusButton()}
      </div>
    )
  }
}
