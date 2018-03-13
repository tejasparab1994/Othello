
const initialState = {
    games: []
};

export default function reducer(state = initialState, action = {})  {
    console.log("lobby reducer is called");

    switch(action.type) {
        case "current_games_set":
            return Object.assign({}, state, { games: action.games});
        default:
            console.log(state);
            return Object.assign({}, state, {games: []});
    }
}