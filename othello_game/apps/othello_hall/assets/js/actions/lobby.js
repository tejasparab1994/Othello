

export function fetchGames(lobbyChannel)  {
    return dispatch => {
        lobbyChannel.on("update_games", payload => {
            dispatch({
                type: "current_games_set",
                games: payload.games
            });
        });

        lobbyChannel.push("current_games", payload => {
           dispatch({
               type: "current_games_set",
               games: payload.games
           });
        });
    }
}