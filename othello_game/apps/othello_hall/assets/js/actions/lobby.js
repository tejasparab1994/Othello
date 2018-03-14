

export function fetchGames(lobbyChannel)  {
    return dispatch => {
        lobbyChannel.on("update_games", payload => {
            console.log("update_games is called");
            dispatch({
                type: "current_games_set",
                games: payload.current_games
            });
        });

        lobbyChannel.push("lobby:current_games").receive( "ok", payload => {
            console.log("Hello current games");
            console.log(payload);
            dispatch({
                type: "current_games_set",
                games: payload.current_games
            });
        });
    }
}