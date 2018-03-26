const initialState = {
    messages: []
};

export default function reducer(state = initialState, action = {})   {
    switch(action.type) {
        case "message_received":    {
            var messages = state.messages.slice();
            messages.push(action.message);
            return Object.assign({}, state, {messages: messages});
        }
        default:
            return state;
    }
}
