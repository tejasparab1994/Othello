import React from 'react';
import {Button} from 'reactstrap';
import {newGame} from '../actions/lobby';

export class NewGame extends React.Component   {


    handleClick(event)   {
        console.log("NewGame handleclick is called");
        const {dispatch, lobby } = this.props;
        dispatch(newGame(lobby));
    }

    render()    {
        return (<button onClick={this.handleClick.bind(this)}>Start Game</button>);
    }

    }