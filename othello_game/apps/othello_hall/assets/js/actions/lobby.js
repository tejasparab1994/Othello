import React from 'react';

// Attribution.
// I would like to attribute this idea of showing the list
// of games in the lobby page to the underlined link.
// https://github.com/bigardone/phoenix-battleship
export function fetchGames(lobbyChannel, socket)  {
    return dispatch => {
        lobbyChannel.on("update_games", payload => {
            dispatch({
                type: "current_games_set",
                games: payload.current_games,
                lobby: lobbyChannel
            });
        });

        lobbyChannel.push("lobby:current_games").receive( "ok", payload => {
            dispatch({
                type: "current_games_set",
                games: payload.current_games,
                lobby: lobbyChannel
            });
        });
    }
}