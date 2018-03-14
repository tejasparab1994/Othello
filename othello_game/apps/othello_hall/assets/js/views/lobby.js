import React from 'react';
import {connect} from 'react-redux';
import {Socket} from "../../../../../deps/phoenix/assets/js/phoenix";
import {fetchGames} from "../actions/lobby";
import { withRouter } from 'react-router-dom';

class LobbyView extends React.Component  {
    componentDidMount() {
        console.log("Component is mounted. Thank God!!!");
        const {dispatch} = this.props;
        const playerName = "sibendu";
        const socket = new Socket("/socket", {params: {playerName: playerName}});
        socket.connect();
        //
        let lobby = socket.channel("lobby:join");
        lobby.join();

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
        console.log(this.props);
        const { games } = this.props;

        if (games.length == 0 ) return "No Games Currently being played";


        const gamesList = games.map( game => {
            return (
                <ListItem key={game.name} game={game}/>
            );
        });


        return (
            <div id = "games" >
                {gamesList}
            </div>
        );
    }
}


function map(state){
    console.log("connect map is called");
    return Object.assign({}, state.lobby);
}

// export default withRouter(connect(map)(LobbyView));
export default connect(map)(LobbyView);


