
const initialState = {
    games: []
};

export default function reducer(state = initialState, action = {})  {
    switch(action.type) {
        case "current_games_set":
            return state;
        default:
            return state;
    }
}