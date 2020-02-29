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

  buildUrlForGettingResponses() {
    //return 'http://localhost:3000/subblogs/' + this.props.subblog_id + '/blogs/' + this.props.blog_id + '/comments/' + this.props.comment_id;
    return 'https://blog-app-andy-strube.herokuapp.com/subblogs/' + this.props.subblog_id + '/blogs/' + this.props.blog_id + '/comments/' + this.props.comment_id;
  }

  getCommentResponses() {
    axios.get(this.buildUrlForGettingResponses())
    .then((res) =>
      this.setResponsesInState(res)
    )
    .catch((err) => console.log(err.response.data));
  }

  moderatorNameSpaceUrlModifier() {
    let UrlModifier = '';
    if(this.props.is_moderator) {
      UrlModifier = 'moderator';
    }
    return UrlModifier;
  }

  buildUrlForDeleteButtons(responseComment) {
    //return 'http://localhost:3000/' + this.moderatorNameSpaceUrlModifier() + '/subblogs/' + this.props.subblog_id + '/blogs/'+ this.props.blog_id + '/comments/' + this.props.comment_id + '/responses/' + responseComment.id;
    return 'https://blog-app-andy-strube.herokuapp.com/' + this.moderatorNameSpaceUrlModifier() + '/subblogs/' + this.props.subblog_id + '/blogs/'+ this.props.blog_id + '/comments/' + this.props.comment_id + '/responses/' + responseComment.id;
  }

  deleteResponseInstance(responseComment) {
    axios.delete(this.buildUrlForDeleteButtons(responseComment))
    .then(() => {
      this.getCommentResponses();
    })
    .catch((err) => console.log(err.response.data));
  }

  addDeleteButton(response) {
    return(
      <button onClick={() => this.deleteResponseInstance(response)} className="btn btn-link make-it-green">
        delete
      </button>
    );
  }

  addEditButton(url) {
    return(
      <button className="btn btn-link">
        <a href={url} className="make-it-green">edit</a>
      </button>
    );
  }

  buildUrlForEditLink(response) {
    //return 'http://localhost:3000/subblogs/' + this.props.subblog_id + '/blogs/'+ this.props.blog_id + '/comments/' + this.props.comment_id + '/responses/' + response.id + '/edit';
    return 'https://blog-app-andy-strube.herokuapp.com/subblogs/' + this.props.subblog_id + '/blogs/'+ this.props.blog_id + '/comments/' + this.props.comment_id + '/responses/' + response.id + '/edit';
  }

  placeEmptyDivs() {
    return(<div></div>);
  }

  setEditAndDeleteButtons(response) {
    const url = this.buildUrlForEditLink(response);
    if(this.props.username === response.username && this.props.user_id === response.user_id) {
      return(<div>{this.addDeleteButton(response)}{this.addEditButton(url)}</div>);
    } else if(this.props.is_moderator) {
      return this.addDeleteButton(response);
    } else if(this.props.username === null && this.props.user_id === null) {
      return this.placeEmptyDivs();
    } else {
      return this.placeEmptyDivs();
    }
  }

  setModeratorIcon(username) {
    if(username === this.props.moderator_username) {
      return(
        <span className="make-it-blue">
          [M]
        </span>
      );
    } else {
      return this.placeEmptyDivs();
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
      return this.placeEmptyDivs();
    }
  }
}
