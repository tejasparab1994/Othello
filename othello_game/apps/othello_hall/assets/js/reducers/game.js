
const initialState = {
    gameName: null
};

export default function reducer(state = initialState, action = {})   {
    switch(action.type) {
        case "new_game_created":    {
            return Object.assign({}, state, {gameName: action.gameName});
        }
        default:
            return state;
    }
}