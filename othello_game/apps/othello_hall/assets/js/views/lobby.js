import React from 'react';
import {connect} from 'react-redux';
import {Socket} from "../../../../../deps/phoenix/assets/js/phoenix";
import {fetchGames} from "../actions/lobby";
import {ListGame} from "../components/listgame"
import {NewGame} from "../components/newgame"


class LobbyView extends React.Component {
    componentDidMount() {
        console.log("Component is mounted. Thank God!!!");
        const {dispatch, lobby} = this.props;

        if (lobby == null) {
            const socket = new Socket("/socket", {params: {playerName: window.playerName}});
            socket.connect();
            let lobby = socket.channel("lobby:join");
            lobby.join();
            dispatch(fetchGames(lobby))
        } else dispatch(fetchGames(lobby));
    }

    render() {
        const {lobby, dispatch} = this.props;
        return (
            <div id="lobby_view">
              <div className="row">
                <div className="col-xl-6 col-xs-offset-4 text-center">
                  <div id="current_games">
                    <table>
                      <tbody>
                        <tr>
                          <th>
                            Current Games
                          </th>
                          <th>
                          </th>
                        </tr>
                        {this.renderCurrentGames()}
                      </tbody>
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
            {
                console.log(game.name);
            }
            return (
                <ListGame key={game.name + game.inProgress} game={game}/>
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
