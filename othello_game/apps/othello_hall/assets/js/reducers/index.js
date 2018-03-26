import { combineReducers }  from 'redux';
import { routerReducer }    from 'react-router-redux';
import lobby                 from './lobby';
import game                 from './game';
import chat                 from './chat';


export default combineReducers({
  routing: routerReducer,
  lobby: lobby,
  game: game,
  chat: chat
});
