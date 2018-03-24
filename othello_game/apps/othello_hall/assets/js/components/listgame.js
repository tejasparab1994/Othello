import React from 'react';

export class ListGame extends React.Component {

    constructor(props) {
        super(props);
        this.state = props.game;
    }

    render() {
        return (
          <table className="card">
            <tr className="card-header">
              <td>
                <h5>{this.state.name}</h5>

              </td>
              <td>
                <a href={getLink(this.state.name)} className='btn btn-primary' role="button">
                  {!this.state.inProgress ? "Join" : "Spectate"}
                </a>
              </td>
            </tr>
          </table>
        );
    }
}


function getLink(gameName) {
    console.log("Get Link is called");
    return "/games/" + gameName;
}
