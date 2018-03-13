import React from 'react';
import {connect} from 'react-redux';
import {Socket} from "../../../../../deps/phoenix/assets/js/phoenix";
import {fetchGames} from "../actions/lobby";

export class LobbyView extends React.Component  {
    componentDidMount() {
        console.log("Component is mounted. Thank God!!!");
        // const {dispatch} = this.props;
        // const playerName = window.playerName;
        // const socket = new Socket("/socket", {params: {playerName: playerName}});
        // socket.connect();
        //
        // let lobby = socket.channel("lobby:join");
        // lobby.join();

        dispatch(fetchGames(lobby))

        // dispatch(fetchGames(lobbyChannel));
    }

    render()    {
        return (
            <div id="current_games">
                {this.renderCurrentGames()}
            </div>
        );
    }

    renderCurrentGames()    {
        const { games } = this.props;

        if (games.length == 0 ) return "No Games Currently being played";


        const gamesList = games.map( game => {
            return (
                <ListItem key={game.name} game={game}/>
            );
        })


        return (
            <div id = "games" >
                {gamesList}
            </div>
        );
    }
}


const map = (state) => (
    { state }
);


export default connect(map)(LobbyView);


