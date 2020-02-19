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
    //axios.get('http://localhost:3000/subblogs/' + this.props.subblog_id + '/blogs/' + this.props.blog_id + '/comments/' + this.props.comment_id)
    axios.get('https://blog-app-andy-strube.herokuapp.com/subblogs/' + this.props.subblog_id + '/blogs/' + this.props.blog_id + '/comments/' + this.props.comment_id)
    .then((res) =>
      this.setResponsesInState(res)
    )
  }

  setResponsesInState(res) {
    const responses =  res.data.map((response) => {
      return <div>
      <div className="make-it-green">
        {response.username}
      </div>   
      {response.response_message}
      <br/><br/></div>;
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
