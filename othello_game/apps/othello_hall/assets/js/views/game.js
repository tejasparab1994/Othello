import React, {Component} from 'react';
import {connect} from 'react-redux';
import {Socket} from "../../../../../deps/phoenix/assets/js/phoenix";
import {registerForGame} from "../actions/game";

class Game extends React.Component {

    constructor(props) {
        super(props);
    }

    componentWillMount() {
        const {dispatch} = this.props;
        const socket = new Socket("/socket", {params: {playerName: window.playerName}});
        socket.connect();
        let gameChannel = socket.channel("games:" + this.props.gameName);
        gameChannel.join();
        dispatch(registerForGame(gameChannel));
    }

    render() {
        console.log(this.props);

        if (this.props.gameData == null) return null;

        return (
            <div className ="game" key ='game'>
                <div className = "game-board" key='game-board'>
                    <Board squares={this.props.gameData.squares} onClick={(i) => this.handleClick(i)} />
                </div>
                <div className= 'game-info'>
                    <div>{status}</div>
                </div>
            </div>
        );
    }
}


const white = "◯";
const black = "●";

class Square extends React.Component {

    constructor(props)  {
        super(props);
        this.state = props;
    }

    Click(){

    }

    renderDisc() {
        if(this.state.color == null) {
            return "";
        }
        if(this.state.color === "white") {
            return white;
        }
        if(this.state.color === "black") {
            return black;
        }
    }

    render() {
        console.log(this.props);
        return (
            <a className="square" onClick={this.Click.bind(this)} >
                {this.renderDisc()}
            </a>
        );
    }
}

class Board extends Component {

    renderSquare(i, j) {
        return <Square key={'square'+i+j} value={this.props.squares[i][j]}
                       onClick={() => this.props.onClick(i, j)} />;
    }

    renderRow(r) {
        var row = [];
        for (var i = 0; i < 8; i++) {
            row.push(this.renderSquare(r, i));
        }
        return (
            <div key={'row'+r}>
                {row}
            </div>
        );
    }

    renderRows() {
        var rows = [];
        for (var i = 0; i < 8; i++) {
            rows.push(this.renderRow(i));
        }
        return (
            <div>
                {rows}
            </div>
        );
    }
    render() {
        console.log(this.props);
        return (
            <div>
                {this.renderRows()}
            </div>
        );
    }
}

const mapStateToProps = (state, props) => {
    console.log(state);
    return Object.assign({}, state.game, props)
}


export default connect(mapStateToProps)(Game);