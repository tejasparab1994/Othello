import {Redirect} from 'react-router-dom';
import React from 'react';
import { push }       from 'react-router-redux';

export function fetchGames(lobbyChannel, socket)  {
    return dispatch => {
        lobbyChannel.on("update_games", payload => {
            console.log("update_games is called");
            dispatch({
                type: "current_games_set",
                games: payload.current_games,
                lobby: lobbyChannel,
                socket: socket
            });
        });

        lobbyChannel.push("lobby:current_games").receive( "ok", payload => {
            console.log("Hello current games");
            console.log(payload);
            dispatch({
                type: "current_games_set",
                games: payload.current_games,
                lobby: lobbyChannel,
                socket: socket
            });
        });
    }
}