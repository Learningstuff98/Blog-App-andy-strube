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
      this.renderResponses(res)
    )
  }

  renderResponses(res) {
    const responses =  res.data.map((response) => {
      return <div><span>{response.response_message}</span></div>;
    });
    this.setState({
      responses,
    });
  }

  invertState() {
    this.setState({
      responsesAreToBeViewed: !this.state.responsesAreToBeViewed
    });
  }

  render() {
    if(this.state.responsesAreToBeViewed) {
      return(
        <div className="comment">
          {this.state.responses.map((response) => {
            return response;
          })}
          <button onClick={() => this.invertState()}>
            hide replies
          </button>
        </div>
      );
    } else {
      return(
        <button onClick={() => this.invertState()}>
          view replies
        </button>
      );
    }
  }
}
