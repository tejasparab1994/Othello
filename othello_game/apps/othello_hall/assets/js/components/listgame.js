import React from 'react';

export class ListGame extends React.Component {

    constructor(props) {
        super(props);
        this.state = props.game;
    }

    render() {
        return (
            <tr>
              <td>
                {this.state.name}
              </td>
              <td>
                <a href={getLink(this.state.name)} class="btn btn-info" role="button">
                  {!this.state.inProgress ? "Join" : "Spectate"}
                </a>
              </td>
            </tr>
        );
    }
}


function getLink(gameName) {
    console.log("Get Link is called");
    return "/games/" + gameName;
}
