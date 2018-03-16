import React from 'react';
import {connect} from 'react-redux';
import {Socket} from "../../../../../deps/phoenix/assets/js/phoenix";
import {fetchGames} from "../actions/lobby";
import {ListGame} from "../components/listgame"
import {NewGame} from "../components/newgame"

class LobbyView extends React.Component {
    componentDidMount() {
        console.log("Component is mounted. Thank God!!!");
        const {dispatch} = this.props;
        console.log("Player name is :" + window.playerName);
        const socket = new Socket("/socket", {params: {playerName: window.playerName}});
        socket.connect();


        let lobby = socket.channel("lobby:join");
        lobby.join();

        dispatch(fetchGames(lobby))
    }

    render() {
        const {lobby, dispatch} = this.props;
        return (
            <div id="lobby_view">
                {/*<div class="row">*/}
                    {/*<div class="col-xs-8 col-xs-offset-2 text-center">*/}
                        {/*<h4>New Game?</h4>*/}
                        {/*<NewGame lobby={lobby} dispatch={dispatch}/>*/}
                    {/*</div>*/}
                {/*</div>*/}
                <div class="row">
                    <div class="col-xs-8 col-xs-offset-5 text-center">
                        <div id="current_games" >
                            <table>
                                <tr>
                                    <th>
                                        Game Name
                                    </th>
                                    <th>

                                    </th>
                                </tr>
                                {this.renderCurrentGames()}
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        );
    }

    renderCurrentGames() {
        const {games} = this.props;

        if (games.length == 0) return "No Games Currently being played";


        const gamesList = games.map(game => {
            return (
                <ListGame game={game}/>
            );
        });

        return gamesList
    }

}


function map(state) {
    console.log("connect map is called");
    return Object.assign({}, state.lobby);
}

// export default withRouter(connect(map)(LobbyView));
export default connect(map)(LobbyView);
