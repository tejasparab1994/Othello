import {Redirect} from 'react-router-dom';
import React from 'react';
import { push }       from 'react-router-redux';
import lobby from "../views/lobby";

export function fetchGames(lobbyChannel)  {
    return dispatch => {
        lobbyChannel.on("update_games", payload => {
            console.log("update_games is called");
            dispatch({
                type: "current_games_set",
                games: payload.current_games,
                lobby: lobbyChannel
            });
        });

        lobbyChannel.push("lobby:current_games").receive( "ok", payload => {
            console.log("Hello current games");
            console.log(payload);
            dispatch({
                type: "current_games_set",
                games: payload.current_games,
                lobby: lobbyChannel
            });
        });
    }
}

export function newGame(lobbyChannel)   {
    console.log("new game is called");
    return (dispatch) => {
        lobbyChannel.push("lobby:new_game").receive("ok", payload => {
            dispatch({
                type: "new_game_created",
                gameName: payload.gameName
            });
            window.location.replace(window.location.protocol + "//" + window.location.hostname + ":" +
                window.location.port + "/" + "game");
            // dispatch(push(`/game`));
        });
    }
}