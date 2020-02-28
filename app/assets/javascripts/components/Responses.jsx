class Responses extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      responses: [],
      responsesAreToBeViewed: false
    }
  }

  componentWillMount() {
    this.getCommentResponses();
  }

  getCommentResponses() {
    axios.get('http://localhost:3000/subblogs/' + this.props.subblog_id + '/blogs/' + this.props.blog_id + '/comments/' + this.props.comment_id)
    //axios.get('https://blog-app-andy-strube.herokuapp.com/subblogs/' + this.props.subblog_id + '/blogs/' + this.props.blog_id + '/comments/' + this.props.comment_id)
    .then((res) =>
      this.setResponsesInState(res)
    )
    .catch((err) => console.log(err.response.data));
  }

  deleteResponseInstance(responseComment) {
    let moderatorNameSpaceUrlModifier = '';
    if(this.props.is_moderator) {
      moderatorNameSpaceUrlModifier = 'moderator';
    }
    axios.delete('http://localhost:3000/' + moderatorNameSpaceUrlModifier + '/subblogs/' + this.props.subblog_id + '/blogs/'+ this.props.blog_id + '/comments/' + this.props.comment_id + '/responses/' + responseComment.id)
    //axios.delete('https://blog-app-andy-strube.herokuapp.com/' + moderatorNameSpaceUrlModifier + '/subblogs/' + this.props.subblog_id + '/blogs/'+ this.props.blog_id + '/comments/' + this.props.comment_id + '/responses/' + responseComment.id)
    .then(() => {
      this.getCommentResponses();
    })
    .catch((err) => console.log(err.response.data));
  }

  setEditAndDeleteButtons(response) {
    const url = 'http://localhost:3000/subblogs/' + this.props.subblog_id + '/blogs/'+ this.props.blog_id + '/comments/' + this.props.comment_id + '/responses/' + response.id + '/edit';
    //const url = 'https://blog-app-andy-strube.herokuapp.com/subblogs/' + this.props.subblog_id + '/blogs/'+ this.props.blog_id + '/comments/' + this.props.comment_id + '/responses/' + response.id + '/edit';
    let editAndDeleteButtons;
    if(this.props.username === response.username && this.props.user_id === response.user_id) {
      editAndDeleteButtons = <div>
        <button onClick={() => this.deleteResponseInstance(response)} className="btn btn-link make-it-green">
          delete
        </button>
        <button className="btn btn-link">
          <a href={url} className="make-it-green">edit</a>
        </button>
      </div>;
    } else if(this.props.is_moderator) {
      editAndDeleteButtons = <div>
        <button onClick={() => this.deleteResponseInstance(response)} className="btn btn-link make-it-green">
          delete
        </button>
      </div>
    } else if (this.props.username === null && this.props.user_id === null) {
      editAndDeleteButtons = <div></div>;
    } else {
      editAndDeleteButtons = <div></div>;
    }
    return editAndDeleteButtons; 
  }

  setModeratorIcon(username) {
    if(username === this.props.moderator_username) {
      return(
        <span className="make-it-blue">
          [M]
        </span>
      );
    } else {
      return(<div></div>);
    }
  }

  setResponsesInState(res) {
    const responses =  res.data.map((response) => {
      return <div className="col-7">
        <div className="make-it-green">
          {response.username}{" "}
          {this.setModeratorIcon(response.username)}
        </div>   
        {response.response_message}
        {this.setEditAndDeleteButtons(response)}
        <br/>
      </div>;
    });
    this.setState({
      responses,
    });
  }

  invertResponseViewStatus() {
    this.setState({
      responsesAreToBeViewed: !this.state.responsesAreToBeViewed
    });
  }

  render() {
    if(this.state.responsesAreToBeViewed) {
      return(
        <div className="response">
          <br/>
          {this.state.responses.map((response) => {
            return response;
          })}
          <button className="make-it-green btn btn-link response-button" onClick={() => this.invertResponseViewStatus()}>
            hide replies
          </button>
        </div>
      );
    } else if(this.state.responses.length > 0) {
      return(
        <div>
          <div className="make-it-green">Total replies: {this.state.responses.length}</div>
          <button className="make-it-green btn btn-link response-button" onClick={() => this.invertResponseViewStatus()}>
            view replies
          </button>
        </div>
      );
    } else {
      return(<div></div>);
    }
  }
}
