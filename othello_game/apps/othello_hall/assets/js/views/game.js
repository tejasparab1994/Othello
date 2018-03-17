import React from 'react';
import {connect} from 'react-redux';
import {Socket} from "../../../../../deps/phoenix/assets/js/phoenix";
import {registerForGame}  from "../actions/game";

class Game extends React.Component{

    constructor(props)  {
        super(props);
    }
    componentDidMount() {
        const {dispatch, gameChannel} = this.props;

        if (!gameChannel) {
            const socket = new Socket("/socket", {params: {playerName: window.playerName}});
            socket.connect();
            let gameChannel = socket.channel("games:" + this.props.gameName);
            gameChannel.join();
            dispatch(registerForGame(gameChannel));
        }
        else
            dispatch(registerForGame(gameChannel));

    }

    render()    {
        console.log(this.props);
        return (
            <div>Game played is {this.props.gameName}</div>
        );
    }
}

const mapStateToProps = (state, props) => {
    console.log(props);
    return Object.assign({}, state.game, props)
}


export default connect(mapStateToProps)(Game);