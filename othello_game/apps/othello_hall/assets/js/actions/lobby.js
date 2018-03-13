

export function fetchGames(lobbyChannel)  {
    return dispatch => {
        lobbyChannel.on("lobby:update_games", payload => {
            dispatch({
                type: "current_games_set",
                games: []
            });
        });

        lobbyChannel.push("lobby:current_games", payload => {
           dispatch({
               type: "current_games_set",
               games: []
           });
        });
    }
}