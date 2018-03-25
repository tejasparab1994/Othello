import React, {Component} from 'react';
import {connect} from 'react-redux';
import {Socket} from "../../../../../deps/phoenix/assets/js/phoenix";
import {registerForGame, markSquare} from "../actions/game";
import $ from 'jquery';
import ChatView from "./chat";

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
        console.log("Rendered Game");

        if (this.props.gameData == null) return null;

        return (
            <div className="game" key='game'>
              <div className="introduction">{this.getInfo()}</div>
              <div className="game-board area-size" key='game-board'>
                <div className="shadow-board">
                  {this.getBoard()}
                </div>
                <div className='game-info'>
                  <div>{status}</div>
                </div>
              </div>
              <div className="chat">
                  <ChatView dispatch={this.props.dispatch} gameChannel={this.props.gameChannel}
                  messages={this.props.messages}/>
              </div>
            </div>
        );
    }

    getInfo(){
      return(
        <div className="container-fluid card card-header visible">
          <h4>
            How to Play Othello
          </h4>
          <p>
            Players battle to finish the game with more of their own pieces on
            the board than their opponent. The game is classed as finished when
            there are no spaces left on the board or there are no more possible
            legal moves for either competitor.
          </p>
          <h5>
            The Game
          </h5>
          <p>
            A legal move is one that consists of, for example, a black piece
            being placed on the board that creates a straight line
            (vertical, horizontal or diagonal) made up of a black piece at
            either end and only white pieces in between. When a player
            achieves this, any white pieces between the two black are turned
            black so that the line becomes entirely black. Same applies if you
            play as white.

          </p>
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
                  gameData={this.props.gameData}
                  gameChannel={this.props.gameChannel}/>
            );
        }
        else if (player1.name === window.playerName || player2.name === window.playerName) {
            return (
                <OppositeTurnBoard dispatch={this.props.dispatch}
                  gameChannel={this.props.gameChannel}
                  gameData={this.props.gameData}/>
            );
        }
        else {
            return (
                <SpectatorBoard dispatch={this.props.dispatch}
                  gameChannel={this.props.gameChannel}
                  gameData={this.props.gameData}/>
            );
        }
    }
}


class Board extends React.Component{

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
              <div id="info_board">
                {this.get_info()}
              </div>
              {this.renderRows()}
              <div id="score_board">
                {score_board(this.props.gameData.player1,
                  this.props.gameData.player2,
                this.props.gameData.in_progress)}
              </div>
            </div>
        );
    }

}

const white = "⚪";
const black = "⚫";

class Square extends React.Component {

    Click() {
        console.log(!this.props.value.disabled);
        console.log(this.props.clickable);
        if (!this.props.value.disabled && this.props.clickable) {
            this.props.dispatch(markSquare(this.props.value.i, this.props.value.j, this.props.gameChannel))
        }
        else {
            window.alert("You are not allowed to click");
        }
    }

    renderDisc() {
        if (this.props.value.color == null) {
            return "";
        }
        if (this.props.value.color === "white") {
            return white;
        }
        if (this.props.value.color === "black") {
            return black;
        }
    }

    render() {

        return (
            <a className="square" style={this.setStyle()} onClick={this.Click.bind(this)}>
              {this.renderDisc()}
            </a>
        );
    }

    setStyle()   {
        if (!this.props.value.disabled && this.props.clickable) {
            return {backgroundColor: 'red'}
        }
        else {
            return null;
        }
    }
}

class OppositeTurnBoard extends Board {

    renderSquare(i, j) {
        return <Square key={'square' + i + j}
          value={this.props.gameData.squares[i][j]}
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
              <div class="card card-header visible" id="info_board">
                {this.get_info()}
              </div>
              {this.renderRows()}
              {score_board(this.props.gameData.player1,
                this.props.gameData.player2,
              this.props.gameData.in_progress)}
            </div>
        );
    }

    get_info() {
        if (this.props.gameData.winner != null) {
            return declare_winner(this.props.gameData.winner);
        }

        return "This is "
            + this.props.gameData.next_turn.name
            + "'s" + " turn";
    }
}

class SpectatorBoard extends Board {
    renderSquare(i, j) {
        return <Square key={'square' + i + j}
          value={this.props.gameData.squares[i][j]}
          gameChannel={this.props.gameChannel}
          dispatch={this.props.dispatch}
          clickable={false}/>;
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
        console.log("Spectator board is rendered");
        return (
            <div>
              <div class="card card-header visible" id="info_board">
                {this.get_info()}
              </div>
              {this.renderRows()}
              {score_board(this.props.gameData.player1,
                this.props.gameData.player2,
              this.props.gameData.in_progress)}
            </div>
        );
    }

    get_info() {

        if (this.props.gameData.winner != null) {
            return declare_winner(this.props.gameData.winner);
        }

        return "This is "
            + this.props.gameData.next_turn.name
            + "'s" + " turn";
    }
}


class MyTurnBoard extends Board {

    constructor(props)  {
        super(props);
    }

    renderSquare(i, j) {
        return <Square key={'square' + i + j}
          value={this.props.gameData.squares[i][j]}
          gameChannel={this.props.gameChannel}
          dispatch={this.props.dispatch}
          clickable={this.props.gameData.in_progress && true}/>;
    }

    get_info() {

        if (this.props.gameData.winner != null) {
            return declare_winner(this.props.gameData.winner);
        }

        if (!this.props.gameData.in_progress)
            return (
              <div className="card card-header visible">
                <h5>
                  Waiting for Player 2 to Join
                </h5>
              </div>);
        else
            return (
              <div className = "card card-header visible">
                <b>
                  This is your turn
                </b>
              </div>);
    }
}

function declare_winner(winner)  {

    if (winner.name === window.playerName)
        return (  <div className = "card card-header visible">
          <h3>
            Congratulations!! You Win!!!
          </h3>
        </div>);
    else
        return (
          <div className = "card card-header visible">
            <h2>
              {winner.name +  " is the winner."}
            </h2>
          </div>)
}

const mapStateToProps = (state, props) => {
    console.log(state);
        return Object.assign({}, state.game, state.chat, props);
}

function score_board(player1, player2, in_progress) {
    if (in_progress) {
        return (
            <div id="score_board">
              <div class= "card card-header scores1 col" id="score_player_1">
                <span>
                  <h5>
                    Player Name(black): {player1.name}
                  </h5>
                </span>
                <span>
                  <h5>
                    Player Score: {player1.score}
                  </h5>
                </span>
              </div>
              <div class="card card-header scores2 col" id="score_player_2">
                <span>
                  <h5>
                    Player Name(white): {player2.name}
                  </h5>
                </span>
                <span>
                  <h5>
                    Player Score: {player2.score}
                  </h5>
                </span>
              </div>
            </div>
        );
    }

    return null;
}

export default connect(mapStateToProps)(Game);
