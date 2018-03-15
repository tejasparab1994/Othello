import React from 'react';
import {Button} from 'reactstrap';
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
                <Button>{ this.state.inProgress? "Spectate" : "Join" }</Button>
              </td>
            </tr>
        );
    }
}
