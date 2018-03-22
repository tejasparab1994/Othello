import React, {Component} from 'react';
import {connect} from 'react-redux';
import {Socket} from "../../../../../deps/phoenix/assets/js/phoenix";
import {registerForGame, markSquare} from "../actions/game";

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
            <div className="game container-fluid" key='game'>
                <div className="game-board area-size offset-2" key='game-board'>
                    {this.getBoard()}
                </div>
                <div className='game-info'>
                    <div>{status}</div>
                </div>
            </div>
        );
    }

    getBoard() {
        let player1 = this.props.gameData.player1;
        let player2 = this.props.gameData.player2;
        let next_turn = this.props.gameData.next_turn;

        if (next_turn.name === window.playerName) {
            return (
                <MyTurnBoard dispatch={this.props.dispatch}
                             squares={this.props.gameData.squares}
                             gameChannel={this.props.gameChannel}/>
            );
        }
        else
            return (
                <OppositeTurnBoard dispatch={this.props.dispatch}
                                   squares={this.props.gameData.squares}
                                   gameChannel={this.props.gameChannel}/>
            );
    }
}


const white = "◯";
const black = "●";

class Square extends React.Component {

    constructor(props) {
        super(props);
        this.state = props;
    }

    Click() {
        if (this.state.value.clickable && this.state.clickable) {
            this.state.dispatch(markSquare(this.state.value.i, this.state.value.j, this.state.gameChannel))
        }
        else {
            window.alert("You are not allowed to click");
        }
    }

    renderDisc() {
        if (this.state.value.color == null) {
            return "";
        }
        if (this.state.value.color === "white") {
            return white;
        }
        if (this.state.value.color === "black") {
            return black;
        }
    }

    render() {

        return (
            <a className="square" onClick={this.Click.bind(this)}>
                {this.renderDisc()}
            </a>
        );
    }
}

class OppositeTurnBoard extends Component {

    renderSquare(i, j) {
        return <Square key={'square' + i + j}
                       value={this.props.squares[i][j]}
                       gameChannel={this.props.gameChannel}
                       clickable={false}
                       dispatch={this.props.dispatch}/>;
    }

    renderRow(r) {
        var row = [];
        for (var i = 0; i < 8; i++) {
            row.push(this.renderSquare(r, i));
        }
        return (
            <div key={'row' + r}>
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
        console.log("Opposite board is rendered");
        return (
            <div>
                {this.renderRows()}
            </div>
        );
    }
}


class MyTurnBoard extends Component {
    renderSquare(i, j) {
        return <Square key={'square' + i + j} value={this.props.squares[i][j]}
                       gameChannel={this.props.gameChannel}
                       dispatch={this.props.dispatch}
                       clickable={true}/>;
    }

    renderRow(r) {
        var row = [];
        for (var i = 0; i < 8; i++) {
            row.push(this.renderSquare(r, i));
        }
        return (
            <div key={'row' + r}>
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
        console.log("My turn board is rendered");
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
