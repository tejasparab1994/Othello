export function registerForGame(gameChannel) {
    return (dispatch) => {
        gameChannel.push("games:register_for_game").receive("ok", payload => {
            dispatch({
                type: "fetch_game_data",
                gameData: payload.gameData,
                gameChannel: gameChannel
            });
        });

        gameChannel.on("update_game", payload => {
            dispatch({
                type: "fetch_game_data",
                gameData: payload.gameData,
                gameChannel: gameChannel
            });
        });
    }
}

export function markSquare(i, j, gameChannel)    {
    var obj = {i: i, j: j}
    return dispatch => {
        gameChannel.push("games:mark_square", obj).receive("ok", payload => {})
    }
}
