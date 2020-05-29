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
    axios.get('http://blog-app-andy-strube.herokuapp.com/moderator/locks/' + this.props.lock_id)
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
    axios.patch('http://blog-app-andy-strube.herokuapp.com/moderator/locks/' + this.props.lock_id, {
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
    let lockAction;
    if(this.props.is_moderator) {
      if(this.state.is_locked) {
        lockAction = 'Unlock';
      } else {
        lockAction = 'Lock';
      }
      return(
        <div onClick={() => this.invertLockedStatus()} className="btn btn-primary make-it-green">
          {lockAction} Post
        </div>
      )
    }
  }

  render() {
    let lockedNotice;
    if(this.state.is_locked) {
      lockedNotice = <div className='make-it-green'>
        <h3>This post is locked. You won't be able to comment</h3>
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
