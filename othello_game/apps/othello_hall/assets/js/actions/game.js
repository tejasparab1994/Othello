

export function registerForGame(gameChannel)    {
    return (dispatch) => {
            gameChannel.push("game:register_for_game").receive("ok", payload => {
                dispatch({
                    type: "fetch_game_data",
                    gameData: payload.gameData
                });
            });
        }
}