import React, { Component } from 'react';

class Board extends Component {
  renderSquare(i) {
    return <Square key={'square'+i} value={this.props.squares[i]} onClick={() => this.props.onClick(i)} />;
  }
  renderRow(r) {
    var row = [];
    for (var i = 0; i < 8; i++) {
      // remove this multiplied by 8 and do ri if you want squares of each
      // row to be 00 01 02... so on functionality
      // i have ran this using a basic react project and have created a basic table grid
      // right now the squares are numbered from 0 to 63 from left to right
      row.push(this.renderSquare(r*8+i));
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
    return (
      <div>
        {this.renderRows()}
      </div>
    );
  }
}

function Square(props) {

  return (
    // <button className="square" onClick={() => props.onClick()}>
    //   {props.value}
    // </button>
    <button className="square" onClick={() => console.log(props.value)}>{props.value}</button>
  );
}


class Game extends Component {
  constructor() {
    super();
    const squares = Array(64).fill(null);
    squares[27]= squares[36] = 'black';
    squares[28]= squares[35] ='white';
    this.state = {
      squares: squares,
      isNext: true,
    };
  }

  handleClick(i) {
    const squares = this.state.squares.slice();
    console.log(squares);
    var current  = this.state.isNext? 'black' :'white';

    this.setState({
      squares: squares,
      isNext: !this.state.isNext,
    });
  }

  render() {
    const squares = this.state.squares.slice();
    const status = 'Next player: ' + (this.state.isNext?'black' :'white');
    return (
      <div className ="game" key ='game'>
        <div className = "game-board" key='game-board'>
          <Board squares={squares} onClick={(i) => this.handleClick(i)} />
        </div>
        <div className= 'game-info'>
          <div>{status}</div>
        </div>

      </div>
    )
  }
}


export default Game;
