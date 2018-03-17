
const initialState = {
    gameName: null,
    gameData: null
};

export default function reducer(state = initialState, action = {})   {
    switch(action.type) {
        case "new_game_created":    {
            return Object.assign({}, state, {gameName: action.gameName});
        }
        case "fetch_game_data": {
            return Object.assign({}, state, {gameData: action.gameData});
        }
        default:
            return state;
    }
}