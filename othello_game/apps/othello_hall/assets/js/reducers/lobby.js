const initialState = {
    games: [],
    lobby: null,
    playerName: null
};

export default function reducer(state = initialState, action = {}) {
    switch (action.type) {
        case "current_games_set":
            return Object.assign({}, state, {
                games: action.games,
                lobby: action.lobby,
                socket: action.socket,
                playerName: window.playerName
            });
        default:
            return Object.assign({}, state, {games: []});
    }
}