export function registerForGame(gameChannel) {
    return (dispatch) => {
        gameChannel.push("games:register_for_game").receive("ok", payload => {
            dispatch({
                type: "fetch_game_data",
                gameData: payload.gameData
            });
        });

        gameChannel.on("update_game", payload => {
            dispatch({
                type: "fetch_game_data",
                gameData: payload.gameData
            });
        });
    }
}