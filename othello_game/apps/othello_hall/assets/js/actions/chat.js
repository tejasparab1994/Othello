export function sendMessage(gameChannel, message) {
    return (dispatch) => {

        console.log(message);
        var obj = {message: message};
        gameChannel.push("new_chat_message", obj).receive("ok", _payload => {
            // dispatch({
            //     type: "fetch_game_data",
            //     gameData: payload.gameData,
            //     gameChannel: gameChannel
            // });
        });
    }
}

export function listen_for_messages(gameChannel)    {
    return (dispatch) => {
        gameChannel.on("messages", payload => {
            console.log("New Message Received:");
            console.log(payload);
            dispatch({
                type: "message_received",
                message: payload
            });
        });
    }
}
